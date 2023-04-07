class DropImportModels < ActiveRecord::Migration[5.2]
  def change
    drop_table :imports_assessments
    drop_table :imports_tags
  end
end
