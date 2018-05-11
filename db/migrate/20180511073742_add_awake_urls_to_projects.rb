class AddAwakeUrlsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :awake_urls, :string, array: true, default: []
  end
end
