class RemoveOrganizersAndSupportersFromDecidimHomesHomes < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_homes_homes, :organizers, :jsonb
    remove_column :decidim_homes_homes, :supporters, :jsonb
  end
end
