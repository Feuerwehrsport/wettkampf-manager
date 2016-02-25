class CreateCertificateTemplates < ActiveRecord::Migration
  def change
    create_table :certificates_templates do |t|
      t.string :name, null: false
      t.string :image, null: false

      t.timestamps null: false
    end
  end
end
