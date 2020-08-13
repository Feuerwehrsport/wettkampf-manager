# frozen_string_literal: true

class Presets::Heedebockpokal < Preset
  def name
    'Heedebockpokal'
  end

  def description_items
    [
      'Frauen: 100m Hindernisbahn, Hakenleitersteigen, AK1-3, Löschangriff',
      'Männer: 100m Hindernisbahn, Hakenleitersteigen, AK1-3, Löschangriff',
    ]
  end

  protected

  def perform
    Competition.update_all(
      name: 'Heedebockpokal',
      place: 'Taura',
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    la = Disciplines::FireAttack.create!

    hb_assessment = Assessment.create!(discipline: hb, gender: :female, name: '100m Frauen')
    Score::Result.create!(assessment: hb_assessment)
    hb_assessment = Assessment.create!(discipline: hb, gender: :female, name: '100m Mädchen AK1')
    Score::Result.create!(assessment: hb_assessment)
    hb_assessment = Assessment.create!(discipline: hb, gender: :female, name: '100m Mädchen AK2')
    Score::Result.create!(assessment: hb_assessment)
    hb_assessment = Assessment.create!(discipline: hb, gender: :female, name: '100m Mädchen AK3')
    Score::Result.create!(assessment: hb_assessment)

    hl_assessment = Assessment.create!(discipline: hl, gender: :female, name: 'HL Frauen')
    Score::Result.create!(assessment: hl_assessment)
    hl_assessment = Assessment.create!(discipline: hl, gender: :female, name: 'HL Mädchen AK1')
    Score::Result.create!(assessment: hl_assessment)
    hl_assessment = Assessment.create!(discipline: hl, gender: :female, name: 'HL Mädchen AK2')
    Score::Result.create!(assessment: hl_assessment)
    hl_assessment = Assessment.create!(discipline: hl, gender: :female, name: 'HL Mädchen AK3')
    Score::Result.create!(assessment: hl_assessment)

    hb_assessment = Assessment.create!(discipline: hb, gender: :male, name: '100m Männer')
    Score::Result.create!(assessment: hb_assessment)
    hb_assessment = Assessment.create!(discipline: hb, gender: :male, name: '100m Jungen AK1')
    Score::Result.create!(assessment: hb_assessment)
    hb_assessment = Assessment.create!(discipline: hb, gender: :male, name: '100m Jungen AK2')
    Score::Result.create!(assessment: hb_assessment)
    hb_assessment = Assessment.create!(discipline: hb, gender: :male, name: '100m Jungen AK3')
    Score::Result.create!(assessment: hb_assessment)

    hl_assessment = Assessment.create!(discipline: hl, gender: :male, name: 'HL Männer')
    Score::Result.create!(assessment: hl_assessment)
    hl_assessment = Assessment.create!(discipline: hl, gender: :male, name: 'HL Jungen AK1')
    Score::Result.create!(assessment: hl_assessment)
    hl_assessment = Assessment.create!(discipline: hl, gender: :male, name: 'HL Jungen AK2')
    Score::Result.create!(assessment: hl_assessment)
    hl_assessment = Assessment.create!(discipline: hl, gender: :male, name: 'HL Jungen AK3')
    Score::Result.create!(assessment: hl_assessment)

    %i[female male].each do |gender|
      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment)
    end
  end
end
