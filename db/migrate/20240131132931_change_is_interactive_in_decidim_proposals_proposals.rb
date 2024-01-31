class ChangeIsInteractiveInDecidimProposalsProposals < ActiveRecord::Migration[6.1]
  def change
    change_column_default :decidim_proposals_proposals, :is_interactive, true
  end
end
