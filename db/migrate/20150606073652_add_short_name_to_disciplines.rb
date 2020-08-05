# frozen_string_literal: true

class AddShortNameToDisciplines < ActiveRecord::Migration[4.2]
  def change
    add_column :disciplines, :short_name, :string, default: '', null: false
  end
end
