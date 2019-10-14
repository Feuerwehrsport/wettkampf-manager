class CreateCertificatesTextFields < ActiveRecord::Migration[4.2]
  def change
    create_table :certificates_text_fields do |t|
      t.integer  :template_id, null: false
      t.decimal  :left,              null: false
      t.decimal  :top,               null: false
      t.decimal  :width,             null: false
      t.decimal  :height,            null: false
      t.integer  :size,              null: false
      t.string   :key, null: false
      t.string   :align, null: false
      t.string   :text

      t.timestamps null: false
    end

    add_index :certificates_text_fields, :template_id
  end
end
