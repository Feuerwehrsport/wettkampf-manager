class AddColorToCertificatesTextFields < ActiveRecord::Migration[4.2]
  def change
    add_column :certificates_text_fields, :color, :string, null: false, default: '000000'
  end
end
