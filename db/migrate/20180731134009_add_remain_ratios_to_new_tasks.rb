class AddRemainRatiosToNewTasks < ActiveRecord::Migration
  def change
    add_column :new_tasks, :remain_ratios, :string
  end
end
