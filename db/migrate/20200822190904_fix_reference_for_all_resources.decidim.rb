# frozen_string_literal: true
# This migration comes from decidim (originally 20180206143340)

class FixReferenceForAllResources < ActiveRecord::Migration[5.1]
  def up
    models = ActiveRecord::Base.descendants.select { |c| c.included_modules.include?(Decidim::HasReference) }.select(&:table_exists?)

    models.each do |model|
      model.find_each(&:touch)
    end
  end

  def down; end
end
