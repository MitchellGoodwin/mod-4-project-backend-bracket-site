class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bracket, null: false, foreign_key: true
      t.integer :seed

      t.timestamps
    end
  end
end
