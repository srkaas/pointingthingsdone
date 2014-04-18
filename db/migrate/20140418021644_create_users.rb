class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.datetime :last_seen
      t.text :total_points
      t.text :current_points
      t.text :points_today

      t.timestamps
    end
  end
end
