class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :code_name
      t.string :name
      t.text :note

      t.timestamps
    end
  end
end
