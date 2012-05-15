class AddUuidToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :uuid, :string
  end
end
