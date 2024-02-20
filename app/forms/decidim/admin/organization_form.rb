# frozen_string_literal: true

module Decidim
  module Admin
    # A form object used to update the current organization from the admin
    # dashboard.
    #
    class OrganizationForm < Form
      include TranslatableAttributes

      mimic :organization

      attribute :name, String
      attribute :reference_prefix, String
      attribute :time_zone, String
      attribute :twitter_handler, String
      attribute :facebook_handler, String
      attribute :instagram_handler, String
      attribute :youtube_handler, String
      attribute :github_handler, String
      attribute :default_locale, String
      attribute :badges_enabled, Boolean
      attribute :user_groups_enabled, Boolean
      attribute :comments_max_length, Integer
      attribute :rich_text_editor_in_public_views, Boolean
      attribute :enable_machine_translations, Boolean
      attribute :machine_translation_display_priority, String
      attribute :enable_participatory_space_filters, Boolean
      attribute :menu_links, String
      attribute :footer_menu_links, String

      attribute :send_welcome_notification, Boolean
      attribute :customize_welcome_notification, Boolean

      translatable_attribute :welcome_notification_subject, String
      translatable_attribute :welcome_notification_body, String

      translatable_attribute :admin_terms_of_use_body, String

      validates :welcome_notification_subject, :welcome_notification_body, translatable_presence: true, if: proc { |form| form.customize_welcome_notification }

      validates :name, presence: true
      validates :time_zone, presence: true
      validates :time_zone, time_zone: true
      validates :default_locale, :reference_prefix, presence: true
      validates :default_locale, inclusion: { in: :available_locales }
      validates :admin_terms_of_use_body, translatable_presence: true
      validates :comments_max_length, numericality: { greater_than: 0 }, if: ->(form) { form.comments_max_length.present? }
      validates :machine_translation_display_priority,
                inclusion: { in: Decidim::Organization::AVAILABLE_MACHINE_TRANSLATION_DISPLAY_PRIORITIES },
                if: :machine_translation_enabled?
      validate :menu_links_json_format
      validate :footer_menu_links_json_format

      def machine_translation_priorities
        Decidim::Organization::AVAILABLE_MACHINE_TRANSLATION_DISPLAY_PRIORITIES.map do |priority|
          [
            priority,
            I18n.t("activemodel.attributes.organization.machine_translation_display_priority_#{priority}")
          ]
        end
      end

      def menu_links_json_format
        begin
          JSON.parse(menu_links.gsub('=>', ':'))
        rescue
          self.errors.add(:menu_links, :invalid)
        end
      end

      def footer_menu_links_json_format
        begin
          JSON.parse(footer_menu_links.gsub('=>', ':'))
        rescue
          self.errors.add(:footer_menu_links, :invalid)
        end
      end

      def self.get_components_links(spaces, space_label)
        spaces_links = spaces.map do |space|
          links = space.components.map do |component|
            label = component.respond_to?('name') ? 'name' : 'title'
            label_pt_br = component.send(label)['pt-br'] || component.send(label)['pt'] || 'Componente'
            url = "/#{space_label}/#{space.slug}/f/#{component.id}"
            { 'id' => (label_pt_br + '_' + component.id.to_s), 'label' => label_pt_br, 'href' => url, "is_visible"=> true }
          end
          label_pt_br = space.send('title')['pt-br'] || space.send('title')['pt'] || 'Espaço'
          { 'id' => (space_label + '_' + space.id.to_s), 'label' => label_pt_br, 'sub_items' => links, "is_visible"=> true }
        end
        spaces_links
      end

      def self.generate_menu_links
        processes = get_components_links(Decidim::ParticipatoryProcess.all, 'processes')

        { 'menu' => processes }.to_json.to_s.gsub(':', '=>')
      end

      def self.update_menu_links(updated_menu_links)
        Decidim::Organization.find(1).update(menu_links: updated_menu_links)
      end

      private

      def available_locales
        current_organization.available_locales
      end

      def machine_translation_enabled?
        Decidim.config.enable_machine_translations
      end
    end
  end
end
