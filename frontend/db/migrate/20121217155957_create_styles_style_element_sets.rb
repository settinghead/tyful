class CreateStylesStyleElementSets < ActiveRecord::Migration
  def change
    create_table :styles_style_element_sets do |t|
      t.integer :style_idelement_id
      t.integer :style_element_set_id

      t.timestamps
    end
  end
end
