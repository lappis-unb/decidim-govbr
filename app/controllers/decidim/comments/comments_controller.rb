# frozen_string_literal: true

module Decidim
  module Comments
    # Controller that manages the comments for a commentable object.
    #
    class CommentsController < Decidim::Comments::ApplicationController
      include Decidim::ResourceHelper
      include Decidim::SkipTimeoutable
      include Decidim::Govbr::MediaAttachmentsHelper

      prepend_before_action :skip_timeout, only: :index
      before_action :authenticate_user!, only: [:create]
      before_action :set_commentable, except: [:destroy, :update]

      helper_method :root_depth, :commentable, :order, :reply?, :reload?, :root_comment

      def index
        enforce_permission_to :read, :comment, commentable: commentable

        @comments = filtered_comments
        @comments_count = commentable.comments_count

        respond_to do |format|
          format.js do
            if reload?
              render :reload
            else
              render :index
            end
          end

          # This makes sure bots are not causing unnecessary log entries.
          format.html { redirect_to commentable_path }
        end
      end

      def update
        set_comment
        enforce_permission_to :update, :comment, comment: comment

        form = Decidim::Comments::CommentForm.from_params(
          params.merge(commentable: comment.commentable)
        ).with_context(
          current_organization: current_organization
        )

        Decidim::Comments::UpdateComment.call(comment, current_user, form) do
          on(:ok) do
            respond_to do |format|
              format.js { render :update }
            end
          end

          on(:invalid) do
            respond_to do |format|
              format.js { render :update_error }
            end
          end
        end
      end

      def update_status
        set_comment

        params[:comment] = {
          status: params[:status]
        }

        params.delete(:status)

        Decidim::Comments::UpdateCommentStatus.call(comment, current_user, params) do
          on(:ok) do
            respond_to do |format|
              format.js { render :update }
            end
          end

          on(:invalid) do
            respond_to do |format|
              format.js { render :update_error }
            end
          end
        end
      end

      def create
        enforce_permission_to :create, :comment, commentable: commentable

        @form = Decidim::Comments::CommentForm.from_params(
          params.merge(commentable: commentable)
        ).with_context(
          current_organization: current_organization,
          current_component: current_component
        )

        Decidim::Comments::CreateComment.call(@form, current_user) do
          on(:ok) do |comment|
            handle_success(comment)

            create_attachment(comment) if form.attachment_file.present?

            respond_to do |format|
              format.js { render :create }
            end
          end

          on(:invalid) do
            @error = if @form.errors[:attachment_file].present?
                       @form.errors[:attachment_file]
                     else
                       t("create.error", scope: "decidim.comments.comments")
                     end

            respond_to do |format|
              format.js { render :error, locals: { error_message: @error } }
            end
          end
        end
      end

      def current_component
        return commentable.component if commentable.respond_to?(:component)
        return commentable.participatory_space if commentable.respond_to?(:participatory_space)

        commentable if Decidim.participatory_space_manifests.find { |manifest| manifest.model_class_name == commentable.class.name }
      end

      def destroy
        set_comment
        @commentable = @comment.commentable

        enforce_permission_to :destroy, :comment, comment: comment

        Decidim::Comments::DeleteComment.call(comment, current_user) do
          on(:ok) do
            @comments_count = @comment.root_commentable.comments_count
            respond_to do |format|
              format.js { render :delete }
            end
          end

          on(:invalid) do
            respond_to do |format|
              format.js { render :deletion_error }
            end
          end
        end
      end

      private

      attr_reader :commentable, :comment, :form

      def set_commentable
        @commentable ||= if commentable_gid
                           GlobalID::Locator.locate_signed(commentable_gid)
                         elsif comment
                           comment.root_commentable
                         end
      end

      def set_comment
        @comment = Decidim::Comments::Comment.find_by(id: params[:id])
      end

      def ensure_commentable!
        raise ActionController::RoutingError, "Not Found" unless commentable
      end

      def handle_success(comment)
        @comment = comment.reload
        @comments_count = case comment_target
                          when Decidim::Comments::Comment
                            comment_target.root_commentable.comments_count
                          else
                            comment_target.comments_count
                          end
      end

      def root_comment
        @root_comment ||= begin
          root_comment = comment
          root_comment = root_comment.commentable while root_comment.commentable.is_a?(Decidim::Comments::Comment)
          root_comment
        end
      end

      def commentable_gid
        case action_name
        when "create"
          params.require(:comment).fetch(:commentable_gid)
        else
          params.fetch(:commentable_gid, nil)
        end
      end

      def reply?(comment)
        comment.root_commentable != comment.commentable
      end

      def order
        params.fetch(:order, "older")
      end

      def reload?
        params.fetch(:reload, 0).to_i == 1
      end

      def root_depth
        params.fetch(:root_depth, 0).to_i
      end

      def commentable_path
        return commentable.polymorphic_resource_path({}) if commentable.respond_to?(:polymorphic_resource_path)

        resource_locator(commentable).path
      end

      def build_attachment(attached_to)
        file = blob(form.attachment_file)
        attachment = Attachment.new(
          attached_to: attached_to
        )

        configure_attachment_file(attachment, file)

        attachment
      end

      def filtered_comments
        SortedComments.for(
          commentable,
          order_by: order,
          after: params.fetch(:after, 0).to_i
        ).reject do |comment|
          next if comment.depth < 1
          next if !comment.deleted? && !comment.hidden?

          comment.commentable.descendants.where(decidim_commentable_type: "Decidim::Comments::Comment").not_hidden.not_deleted.blank?
        end
      end

      def create_attachment(comment)
        @attachment = build_attachment(comment)

        Decidim.traceability.perform_action!(:create, Decidim::Attachment, @user) do
          @attachment.save!
        end
      end

      def configure_attachment_file(attachment, file)
        attachment.title = { 'pt-BR': file.filename }
        attachment.file = form.attachment_file
        attachment.content_type = file.content_type
      end
    end
  end
end
