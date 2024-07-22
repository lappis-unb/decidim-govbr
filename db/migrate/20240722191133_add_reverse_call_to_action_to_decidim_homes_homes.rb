class AddReverseCallToActionToDecidimHomesHomes < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_homes_homes, :reverse_call_to_action, :boolean
  end
end
