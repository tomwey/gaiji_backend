class RemoveIndexFromProjects < ActiveRecord::Migration
  def change
    remove_index :projects, :bundle_id
  end
end
