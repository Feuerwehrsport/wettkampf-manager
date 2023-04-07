# frozen_string_literal: true

class Presets::MvCupSingle < Preset
  def name
    'MV-Cup (HL, HB)'
  end

  def description_items
    [
      'Frauen: 100m Hindernisbahn, Hakenleitersteigen, Zweikampf',
      'Männer: 100m Hindernisbahn, Hakenleitersteigen, Zweikampf',
    ]
  end

  protected

  def perform
    Competition.update_all(
      name: 'MV-Cup',
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    zk = Disciplines::DoubleEvent.create!

    { female: 'Frauen', male: 'Männer' }.each do |gender, name|
      band = Band.create!(gender: gender, name: name)
      zk_assessment = Assessment.create!(discipline: zk, band: band)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, band: band)
      hb_result = Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result)
      hb_result.update!(series_assessments: series(hb_result, 'MV-Hinderniscup'))

      hl_assessment = Assessment.create!(discipline: hl, band: band)
      hl_result = Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result)
      hl_result.update!(series_assessments: series(hb_result, 'MV-Steigercup'))
    end
  end
end
