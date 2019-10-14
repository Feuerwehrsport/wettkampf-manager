class AddFontToCertificatesTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :certificates_templates, :font2, :string
    add_column :certificates_text_fields, :font, :string, default: :regular, null: false
  end
end
