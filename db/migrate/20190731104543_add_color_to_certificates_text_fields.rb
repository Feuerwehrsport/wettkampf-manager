class AddColorToCertificatesTextFields < ActiveRecord::Migration
  def change
    add_column :certificates_text_fields, :color, :string, null: false, default: '000000'
  end
end
