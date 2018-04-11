class Presets::EuregioCup < Preset
  def name
    'EuregioCup 2018 (HL, HB, LA, FS)'
  end

  def description_items
    [
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer',
      '6 Personen von 8 gehen in die Mannschaftswertung ein',
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung',
      'Löschangriff und 4x100m Staffel für Frauen und Männer',
      'Gesamtwertung mit 1. Platz => 1 Negativpunkt',
      'Finalläufe für Einzeldisziplinen',
    ]
  end

  protected

  def perform
    @d3 = Date.parse('2018-08-03')
    @d4 = Date.parse('2018-08-04')

    Competition.update_all(
      group_score_count: 6,
      group_assessment: true,
      competition_result_type: 'places_to_points',
      show_bib_numbers: true,
      lottery_numbers: true,
      name: 'EuregioCup',
      date: @d3,
    )
    @youth_tag = PersonTag.create!(name: 'U20', competition: Competition.first)

    @hb = Disciplines::ObstacleCourse.create!
    @hl = Disciplines::ClimbingHookLadder.create!
    @fs = Disciplines::FireRelay.create!(like_fire_relay: true)
    @zk = Disciplines::DoubleEvent.create!
    @la = Disciplines::FireAttack.create!

    %i[female male].map { |gender| for_gender(gender) }
  end

  def for_gender(gender)
    competition_result = Score::CompetitionResult.create(gender: gender, result_type: :places_to_points,
                                                         name: 'EuregioCup')

    zk_assessment = Assessment.create!(discipline: @zk, gender: gender)
    zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)
    zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment,
                                                       tag_references_attributes: [{ tag_id: @youth_tag.id }])

    hb_assessment = Assessment.create!(discipline: @hb, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result, date: @d3)
    Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result_youth,
                          tag_references_attributes: [{ tag_id: @youth_tag.id }], date: @d3)
    Score::Result.create!(assessment: hb_assessment, name: "#{hb_assessment.decorate} - Sechstelfinale", date: @d4)
    Score::Result.create!(assessment: hb_assessment, name: "#{hb_assessment.decorate} - Halbfinale", date: @d4)
    Score::Result.create!(assessment: hb_assessment, name: "#{hb_assessment.decorate} - Finale", date: @d4)

    hl_assessment = Assessment.create!(discipline: @hl, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result, date: @d3)
    Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result_youth,
                          tag_references_attributes: [{ tag_id: @youth_tag.id }], date: @d3)
    Score::Result.create!(assessment: hl_assessment, name: "#{hl_assessment.decorate} - Sechstelfinale", date: @d4)
    Score::Result.create!(assessment: hl_assessment, name: "#{hl_assessment.decorate} - Halbfinale", date: @d4)
    Score::Result.create!(assessment: hl_assessment, name: "#{hl_assessment.decorate} - Finale", date: @d4)

    la_assessment = Assessment.create!(discipline: @la, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: la_assessment, group_assessment: true, date: @d4)

    fs_assessment = Assessment.create!(discipline: @fs, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: fs_assessment, group_assessment: true, date: @d4)
  end
end
