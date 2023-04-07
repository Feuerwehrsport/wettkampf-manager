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
    { female: 'Frauen', male: 'Männer' }.map do |gender, name|
      band = Band.create!(gender: gender, name: name)
      la_assessment = Assessment.create!(discipline: la, band: band)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)
    end
  end
end
