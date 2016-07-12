class Presets::DM < Preset
  def name
    'Deutsche Meisterschaft 2016 (HL, HB, GS, LA, FS)'
  end

  def description_items
    [
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer',
      '4 Personen von 8 gehen in die Mannschaftswertung ein',
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung',
      'Löschangriff und 4x100m Staffel für Frauen und Männer',
      'Gruppenstaffete für Frauen',
      'Gesamtwertung mit 1. Platz => 1 Negativpunkt',
      'Separate Löschangriff Wertung',
    ]
  end

  protected

  def perform
    Competition.update_all(
      group_score_count: 6,
      group_assessment: true, 
      competition_result_type: 'places_to_points',
      show_bib_numbers: true,
      lottery_numbers: true,
    )
    youth_tag = PersonTag.create!(name: 'U20', competition: Competition.first)
    complete_tag = TeamTag.create!(name: 'Komplett', competition: Competition.first)

    @hb = Disciplines::ObstacleCourse.create!
    @hl = Disciplines::ClimbingHookLadder.create!
    @gs = Disciplines::GroupRelay.create!
    @fs = Disciplines::FireRelay.create!
    @zk = Disciplines::DoubleEvent.create!
    @la = Disciplines::FireAttack.create!

    competition_results = [:female, :male].map do |gender|
      competition_result = Score::CompetitionResult.create(gender: gender, result_type: 'places_to_points', name: 'Deutsche Feuerwehrmeisterschaft')

      zk_assessment = Assessment.create!(discipline: @zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)
      zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment, tag_references_attributes: [{ tag_id: youth_tag.id }])

      hb_assessment = Assessment.create!(discipline: @hb, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result, date: Date.parse('2016-07-29'))
      Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result_youth, tag_references_attributes: [{ tag_id: youth_tag.id }], date: Date.parse('2016-07-29'))
      Score::Result.create!(assessment: hb_assessment, name: "#{hb_assessment.decorate.to_s} - Finale")

      hl_assessment = Assessment.create!(discipline: @hl, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result, date: Date.parse('2016-07-28'))
      Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result_youth, tag_references_attributes: [{ tag_id: youth_tag.id }], date: Date.parse('2016-07-28'))
      Score::Result.create!(assessment: hl_assessment, name: "#{hl_assessment.decorate.to_s} - Finale", date: Date.parse('2016-07-28'))

      la_assessment = Assessment.create!(discipline: @la, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: la_assessment, group_assessment: false)
      Score::Result.create!(assessment: la_assessment, group_assessment: true, tag_references_attributes: [{ tag_id: complete_tag.id }])

      fs_assessment = Assessment.create!(discipline: @fs, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: fs_assessment, group_assessment: true, date: Date.parse('2016-07-29'))

      competition_result
    end

    gs_assessment = Assessment.create!(discipline: @gs, gender: :female, score_competition_result: competition_results.first)
    Score::Result.create!(assessment: gs_assessment, group_assessment: true, date: Date.parse('2016-07-29'))
  end
end