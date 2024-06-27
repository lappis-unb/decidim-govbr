# frozen_string_literal: true

module Decidim
  module Proposals
    # A command with all the business logic when a user creates a new proposal.
    class CreateProposal < Decidim::Command
      include ::Decidim::MultipleAttachmentsMethods
      include GalleryMethods
      include HashtagsMethods

      # Public: Initializes the command.
      #
      # form         - A form object with the params.
      # current_user - The current user.
      # coauthorships - The coauthorships of the proposal.
      def initialize(form, current_user, coauthorships = nil)
        @form = form
        @current_user = current_user
        @coauthorships = coauthorships
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the proposal.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?
        return broadcast(:limit_reached) if proposal_limit_reached?

        if process_attachments?
          build_attachments
          return broadcast(:attachment_invalid) if attachments_invalid?
        end

        if process_gallery?
          build_gallery
          return broadcast(:attachment_invalid) if gallery_invalid?
        end

        transaction do
          create_proposal

          photo_cleanup!
          document_cleanup!

          create_gallery if process_gallery?
          create_attachments(first_weight: first_attachment_weight) if process_attachments?
        end

        broadcast(:ok, proposal)
      end

      private

      attr_reader :form, :proposal, :current_user, :attachment

      # Prevent PaperTrail from creating an additional version
      # in the proposal multi-step creation process (step 1: create)
      #
      # A first version will be created in step 4: publish
      # for diff rendering in the proposal version control
      def create_proposal
        PaperTrail.request(enabled: false) do
          @proposal = Decidim.traceability.perform_action!(
            :create,
            Decidim::Proposals::Proposal,
            @current_user,
            visibility: "public-only"
          ) do
            proposal = Proposal.new(
              title: {
                I18n.locale => title_with_hashtags
              },
              body: {
                I18n.locale => body_with_hashtags
              },
              component: form.component,
              category: form.category,
              address: form.address,
              latitude: form.latitude,
              longitude: form.longitude
            )
            proposal.add_coauthor(@current_user, user_group: user_group)
            proposal.save!
            @attached_to = proposal
          end
        end
      end

      def proposal_limit_reached?
        return false if @coauthorships.present?

        proposal_limit = form.current_component.settings.proposal_limit

        return false if proposal_limit.zero?

        if user_group
          user_group_proposals.count >= proposal_limit
        else
          current_user_proposals.count >= proposal_limit
        end
      end

      def user_group
        @user_group ||= Decidim::UserGroup.find_by(organization: organization, id: form.user_group_id)
      end

      def organization
        @organization ||= @current_user.organization
      end

      def current_user_proposals
        Proposal.from_author(@current_user).where(component: form.current_component).except_withdrawn.where.not(published_at: nil)
      end

      def user_group_proposals
        Proposal.from_user_group(@user_group).where(component: form.current_component).except_withdrawn.where.not(published_at: nil)
      end

      def first_attachment_weight
        return 1 if proposal.photos.count.zero?

        proposal.photos.count
      end
    end
  end
end
