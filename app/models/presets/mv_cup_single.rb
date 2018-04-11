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

    %i[female male].each do |gender|
      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      hb_result = Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result)
      hb_result.update!(series_assessments: series(hb_result, 'MV-Hinderniscup'))

      hl_assessment = Assessment.create!(discipline: hl, gender: gender)
      hl_result = Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result)
      hl_result.update!(series_assessments: series(hb_result, 'MV-Steigercup'))
    end
  end
end
