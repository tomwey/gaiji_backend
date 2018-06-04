class AddPortalUrlsToNewTasks < ActiveRecord::Migration
  def change
    add_column :new_tasks, :portal_urls, :string, array: true, default: []
  end
end
