# frozen_string_literal: true

module Decidim
  module Admin
    # This command gets called when a component is created from the admin panel.
    class UpdateComponent < Decidim::Command
      attr_reader :form, :component, :previous_settings, :current_participatory_space

      # Public: Initializes the command.
      #
      # form    - The form from which the data in this component comes from.
      # component - The component to update.
      def initialize(form, component, user, current_participatory_space)
        @manifest = component.manifest
        @form = form
        @component = component
        @user = user
        @current_participatory_space = current_participatory_space
      end

      # Public: Creates the Component.
      #
      # Broadcasts :ok if created, :invalid otherwise.
      def call
        return broadcast(:invalid) if form.invalid?

        Decidim.traceability.perform_action!("update", @component, @user) do
          transaction do
            update_component
            run_hooks
          end
        end

        broadcast(:ok, settings_changed?, previous_settings, current_settings)
      end

      private

      def update_component
        UpdateBadgeProposals.call(@component, @user) if permitted_to_insert_label?

        @previous_settings = @component.attributes["settings"].with_indifferent_access
        @component.name = form.name
        @component.weight = form.weight
        @component.hide_in_menu = form.hide_in_menu
        @component.singular_name = form.singular_name
        @component.menu_name = form.menu_name

        restore_readonly_settings!

        @component.settings = form.settings
        @component.default_step_settings = form.default_step_settings
        @component.step_settings = form.step_settings

        @settings_changed = @component.settings_changed?

        @component.save!
      end

      def permitted_to_insert_label?
        active_step_p = current_participatory_space.steps.where(active: true).first.id

        @component.manifest_name == "proposals" &&
          (params[:component][:step_settings][active_step_p.to_s][:votes_enabled] != @component.step_settings[active_step_p.to_s][:votes_enabled]) &&
          (params[:component][:step_settings][active_step_p.to_s][:votes_enabled] == "false")
      end

      def run_hooks
        @manifest.run_hooks(:update, @component)
      end

      def settings_changed?
        @settings_changed
      end

      def current_settings
        @component.attributes["settings"]
      end

      # Keep previous values for readonly settings
      def restore_readonly_settings!
        browse_readonly_settings("global") do |attribute|
          form.settings[attribute] = @previous_settings.dig("global", attribute)
        end

        browse_readonly_settings("step") do |attribute|
          form.default_step_settings[attribute] = @previous_settings.dig("default_step", attribute) if form.default_step_settings.present?
          if form.step_settings.present?
            form.step_settings.each do |step_name, step|
              step[attribute] = @previous_settings.dig("steps", step_name, attribute)
            end
          end
        end
      end

      def browse_readonly_settings(settings_name)
        @component.manifest.settings(settings_name).attributes
                  .select { |_attribute, obj| obj.readonly?(component: @component) }
                  .each { |attribute, _obj| yield(attribute) }
      end
    end
  end
end
