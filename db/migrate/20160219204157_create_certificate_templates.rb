# frozen_string_literal: true

class CreateCertificateTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :certificates_templates do |t|
      t.string :name, null: false
      t.string :image
      t.string :font

      t.timestamps null: false
    end
  end
end
