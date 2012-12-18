class CreateStyleElementSets < ActiveRecord::Migration
  def change
    create_table :style_element_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
