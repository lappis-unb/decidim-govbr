# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # A form object used to copy a participatory processes from the admin
      # dashboard.
      #
      class ParticipatoryProcessCopyForm < Form
        include TranslatableAttributes

        translatable_attribute :title, String

        mimic :participatory_process

        attribute :slug, String
        attribute :from_template, Boolean
        attribute :copy_steps, Boolean
        attribute :copy_categories, Boolean
        attribute :copy_components, Boolean

        validates :slug, presence: true, format: { with: Decidim::ParticipatoryProcess.slug_format }
        validates :title, translatable_presence: true
        validate :slug_uniqueness

        def map_model(model)
          super

          self.slug = ""
          self.from_template = self.copy_steps = self.copy_categories = self.copy_components = true if model.is_template
        end

        private

        def slug_uniqueness
          return unless OrganizationParticipatoryProcesses.new(current_organization).query.where(slug: slug).where.not(id: id).any?

          errors.add(:slug, :taken)
        end
      end
    end
  end
end
