class AddDataColumnToTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :content, :jsonb, null: false, default: {}
  end
end
