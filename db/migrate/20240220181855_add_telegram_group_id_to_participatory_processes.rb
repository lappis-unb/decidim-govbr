class AddTelegramGroupIdToParticipatoryProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :group_chat_id, :string
  end
end
