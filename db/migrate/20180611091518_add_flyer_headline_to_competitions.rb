# frozen_string_literal: true

class AddFlyerHeadlineToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :flyer_headline, :string
  end
end
