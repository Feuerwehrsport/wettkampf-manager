class Presets::LandesmeisterschaftBrandenburg2017 < Preset
  def name
    'Landesmeisterschaft Brandenburg 2017 (HL, HB, GS, LA, FS)'
  end

  def description_items
    [
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer',
      '3 Personen von 4 gehen in die Mannschaftswertung ein',
      'Löschangriff und 4x100m Staffel für Frauen und Männer',
      'Gruppenstaffete für Frauen',
    ]
  end

  protected

  def perform
    Competition.update_all(
      group_score_count: 3,
      group_run_count: 4,
      group_assessment: true,
      date: Date.parse('2017-09-16'),
      name: 'Landesmeisterschaft Brandenburg 2017',
      place: 'Doberlug-Kirchhain',
    )
    @hb = Disciplines::ObstacleCourse.create!
    @hl = Disciplines::ClimbingHookLadder.create!
    @gs = Disciplines::GroupRelay.create!
    @fs = Disciplines::FireRelay.create!(like_fire_relay: true)
    @zk = Disciplines::DoubleEvent.create!
    @la = Disciplines::FireAttack.create!

    %i[female male].map do |gender|
      zk_assessment = Assessment.create!(discipline: @zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: @hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result,
                            date: Date.parse('2017-09-15'))

      hl_assessment = Assessment.create!(discipline: @hl, gender: gender)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result,
                            date: Date.parse('2017-09-15'))

      la_assessment = Assessment.create!(discipline: @la, gender: gender)
      Score::Result.create!(assessment: la_assessment, group_assessment: true, date: Date.parse('2017-09-16'))

      fs_assessment = Assessment.create!(discipline: @fs, gender: gender)
      Score::Result.create!(assessment: fs_assessment, group_assessment: true, date: Date.parse('2017-09-16'))
    end

    gs_assessment = Assessment.create!(discipline: @gs, gender: :female)
    Score::Result.create!(assessment: gs_assessment, group_assessment: true, date: Date.parse('2017-09-16'))
  end
end
