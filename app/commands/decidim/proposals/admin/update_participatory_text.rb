# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      # A command with all the business logic when an admin updates participatory text proposals.
      class UpdateParticipatoryText < Decidim::Command
        include Decidim::TranslatableAttributes

        # Public: Initializes the command.
        #
        # form - A PreviewParticipatoryTextForm form object with the params.
        def initialize(form)
          @form = form
          @failures = {}
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid, @failures) if form.invalid?

          transaction do
            update_contents_and_resort_proposals(form)
          end

          if @failures.any?
            broadcast(:invalid, @failures)
          else
            broadcast(:ok)
          end
        end

        private

        attr_reader :form

        # Prevents PaperTrail from creating versions while updating participatory text proposals.
        # A first version will be created when publishing the Participatory Text.
        def update_contents_and_resort_proposals(form)
          PaperTrail.request(enabled: false) do
            form.proposals.each do |prop_form|
              add_failure(prop_form) if prop_form.invalid?

              if prop_form.deleted
                destroy_proposal(prop_form)
              else
                update_proposal(prop_form)
              end
            end

            create_new_proposal if form.should_create_new_proposal?
          end
          raise ActiveRecord::Rollback if @failures.any?
        end

        def update_proposal(prop_form)
          proposal = Proposal.where(component: form.current_component).find(prop_form.id)
          proposal.set_list_position(prop_form.position) if proposal.position != prop_form.position

          return if proposal.votes.any?

          proposal.title = { I18n.locale => translated_attribute(prop_form.title) }
          proposal.body = if proposal.participatory_text_level == ParticipatoryTextSection::LEVELS[:article]
                            { I18n.locale => translated_attribute(prop_form.body) }
                          else
                            { I18n.locale => "" }
                          end
          proposal.is_interactive = prop_form.is_interactive
          add_failure(proposal) unless proposal.save
        end

        def destroy_proposal(prop_form)
          Proposal.where(component: form.current_component).find(prop_form.id).destroy
        end

        def create_new_proposal
          attributes = {
            component: form.current_component,
            title: { I18n.locale => I18n.t(form.proposal_to_add, scope: "decidim.proposals.admin.participatory_texts.section.levels") },
            body: { I18n.locale => "" },
            participatory_text_level: form.proposal_to_add,
            is_interactive: true
          }

          new_proposal = Decidim::Proposals::ProposalBuilder.create(
            attributes: attributes,
            author: form.current_user.organization,
            action_user: form.current_user
          )
          add_failure(new_proposal) unless new_proposal.persisted?
        end

        def add_failure(proposal)
          return if proposal.errors.empty?

          @failures[proposal.id] = proposal.errors.full_messages
        end
      end
    end
  end
end
