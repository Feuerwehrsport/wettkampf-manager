# frozen_string_literal: true

class Presets::FireAttack < Preset
  def name
    'Löschangriff-Pokallauf (LA)'
  end

  def description_items
    [
      'Löschangriff für Frauen und Männer',
    ]
  end

  protected

  def perform
    la = Disciplines::FireAttack.create!
    %i[female male].map do |gender|
      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)
    end
  end
end
