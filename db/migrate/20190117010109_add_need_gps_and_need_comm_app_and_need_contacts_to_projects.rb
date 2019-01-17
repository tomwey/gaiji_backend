class AddNeedGpsAndNeedCommAppAndNeedContactsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :need_gps, :boolean, default: false
    add_column :projects, :need_comm_app, :boolean, default: false
    add_column :projects, :need_contacts, :boolean, default: false
  end
end
