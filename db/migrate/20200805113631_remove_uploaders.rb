class RemoveUploaders < ActiveRecord::Migration[5.2]
  def change
    change_table :certificates_templates do
      remove_column :certificates_templates, :image
      remove_column :certificates_templates, :font
      remove_column :certificates_templates, :font2
    end

    remove_column :imports_configurations, :file
  end
end
