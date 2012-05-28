class AddPrivateToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :private, :boolean, :default => false
    add_index :templates, :private,  unique: false
  end
end
