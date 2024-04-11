class AddTemplateProcessToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_reference :decidim_organizations, :template_process, index: true
  end
end
