class CreateTagReferences < ActiveRecord::Migration[4.2]
  def change
    create_table :tag_references do |t|
      t.references :tag, null: false
      t.references :taggable, null: false, polymorphic: true
      t.timestamps null: false
    end
  end
end
