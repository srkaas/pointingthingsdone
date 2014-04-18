class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.boolean :activated
      t.boolean :completed
      t.text :description
      t.integer :urgency
      t.integer :weight

      t.timestamps
    end
  end
end
