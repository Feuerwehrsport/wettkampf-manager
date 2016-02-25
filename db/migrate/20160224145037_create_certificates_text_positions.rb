class CreateCertificatesTextPositions < ActiveRecord::Migration
  def change
    create_table :certificates_text_positions do |t|
      t.references :template, null: false
      t.string :key, null: false
      t.integer :top, null: false
      t.integer :left, null: false
      t.string :align, null: false
      t.integer :size, null: false

      t.timestamps null: false
    end
  end
end
