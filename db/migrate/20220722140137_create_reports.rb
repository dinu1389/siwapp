class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :name
      t.references :template, index: true, type: :integer

      t.timestamps
    end
  end
end
