class AddIsInteractiveToDecidimProposalsProposals < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_proposals_proposals, :is_interactive, :boolean, default: true
  end
end
