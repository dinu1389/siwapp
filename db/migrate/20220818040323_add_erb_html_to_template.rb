class AddErbHtmlToTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :erb_html, :text
  end
end
