class AddBadgeArrayToDecidimProposalsProposals < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_proposals_proposals, :badge_array, :string, array: true, default: []
  end
end
