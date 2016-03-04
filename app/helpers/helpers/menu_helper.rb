module Helpers::MenuHelper
  class MenuItem < Struct.new(:label, :controller_path, :action)
    def url
      { controller: controller_path, action: (action || :index) }
    end
  end

  def main_menu_items
    items = [
      MenuItem.new("Überslicht", '/dashboard', :show),
      MenuItem.new("Mannschaften", '/teams'),
      MenuItem.new("Wettkämpfer", '/people'),
      MenuItem.new("Startlisten", '/score/lists'),
      MenuItem.new("Ergebnisse", '/score/results'),
    ]
    
    items.push(MenuItem.new("Gesamtwertung", '/score/competition_results')) if Competition.result_type.present?
    items.push(MenuItem.new("D-Cup-Wertung", '/d_cup/single_competitor_results')) if Competition.one.d_cup?

    items
  end

  def admin_menu_items
    [
      MenuItem.new("Disziplinen", '/disciplines'),
      MenuItem.new("Wertungen", '/assessments'),
      MenuItem.new("Urkunden", '/certificates/templates'),
      MenuItem.new("Wettkampf", '/competitions', :edit),
      MenuItem.new("Passwort", '/users', :edit),
      MenuItem.new("Abmelden", '/sessions', :destroy),
    ]
  end
end