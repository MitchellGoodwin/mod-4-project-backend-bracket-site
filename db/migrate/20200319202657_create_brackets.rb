class CreateBrackets < ActiveRecord::Migration[6.0]
  def change
    create_table :brackets do |t|
      t.string :name
      t.text :desc
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
