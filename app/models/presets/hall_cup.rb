# frozen_string_literal: true

class Presets::HallCup < Preset
  def name
    'Hallenpokal HB + FS'
  end

  def description_items
    [
      '100m Hindernisbahn für Frauen und Männer',
      '4x100m für Frauen und Männer',
    ]
  end

  protected

  def perform
    hb = Disciplines::ObstacleCourse.create!
    fs = Disciplines::FireRelay.create!(like_fire_relay: true)

    %i[female male].each do |gender|
      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, group_assessment: false)

      fs_assessment = Assessment.create!(discipline: fs, gender: gender)
      Score::Result.create!(assessment: fs_assessment, group_assessment: false)
    end
  end
end
