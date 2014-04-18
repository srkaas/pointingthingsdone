class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :contents

      t.timestamps
    end
  end
end
