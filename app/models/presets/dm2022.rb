# frozen_string_literal: true

class Presets::Dm2022 < Preset
  def name
    'Deutsche Meisterschaft 2022 (HL, HB, ZK, LA, FS, GS)'
  end

  def description_items
    [
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer',
      '6 Personen von 8 gehen in die Mannschaftswertung ein',
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung',
      'Löschangriff und 4x100m Staffel für Frauen und Männer',
      'Gruppenstaffete für Frauen',
      'Gesamtwertung mit 1. Platz => 1 Negativpunkt',
      'Finalläufe für Einzeldisziplinen',
    ]
  end

  protected

  def perform
    @d3 = Date.parse('2022-06-03')
    @d4 = Date.parse('2022-06-04')
    @d5 = Date.parse('2022-06-05')

    Competition.update_all(
      group_score_count: 6,
      group_assessment: true,
      competition_result_type: 'places_to_points',
      show_bib_numbers: true,
      lottery_numbers: true,
      federal_states: true,
      name: 'Deutsche Feuerwehrmeisterschaft 2022',
      date: @d3,
      place: 'Mühlhausen',
      hostname: 'dm2022.feuerwehrsport-statistik.de',
      flyer_headline: 'Webseite mit Ergebnissen im Internet',
      flyer_text: "- Startlisten\n- Ergebnisse\n- Gesamtwertung",
    )
    @sport_tag = TeamTag.create!(name: 'Sport', competition: Competition.first)
    @youth_tag = PersonTag.create!(name: 'U20', competition: Competition.first)

    @hb = Disciplines::ObstacleCourse.create!
    @hl = Disciplines::ClimbingHookLadder.create!
    @fs = Disciplines::FireRelay.create!(like_fire_relay: true)
    @gs = Disciplines::GroupRelay.create!
    @zk = Disciplines::DoubleEvent.create!
    @la = Disciplines::FireAttack.create!

    @lists = {}

    %i[female male].map { |gender| for_gender(gender) }

    create_sport_teams
    create_la_teams
  end

  def for_gender(gender)
    competition_result = Score::CompetitionResult.create(gender: gender, result_type: :places_to_points,
                                                         name: 'Deutsche Feuerwehrmeisterschaft')

    zk_assessment = Assessment.create!(discipline: @zk, gender: gender)
    zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)
    zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment,
                                                       tag_references_attributes: [{ tag_id: @youth_tag.id }])

    hl_assessment = Assessment.create!(discipline: @hl, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result, date: @d3)
    Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result_youth,
                          tag_references_attributes: [{ tag_id: @youth_tag.id }], date: @d3)
    Score::Result.create!(assessment: hl_assessment, name: "#{hl_assessment.decorate} - Finale", date: @d3)

    hb_assessment = Assessment.create!(discipline: @hb, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result, date: @d4)
    Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result_youth,
                          tag_references_attributes: [{ tag_id: @youth_tag.id }], date: @d4)
    Score::Result.create!(assessment: hb_assessment, name: "#{hb_assessment.decorate} - Finale", date: @d4)

    if gender == :female
      gs_assessment = Assessment.create!(discipline: @gs, gender: :female, score_competition_result: competition_result)
      Score::Result.create!(assessment: gs_assessment, group_assessment: true, date: @d4)
    end

    fs_assessment = Assessment.create!(discipline: @fs, gender: gender, score_competition_result: competition_result)
    Score::Result.create!(assessment: fs_assessment, group_assessment: true, date: @d4)

    la_assessment = Assessment.create!(discipline: @la, gender: gender, score_competition_result: competition_result)
    sport_la = Score::Result.create!(assessment: la_assessment, group_assessment: true, date: @d5,
                                     tag_references_attributes: [{ tag_id: @sport_tag.id }])

    la = Score::Result.create!(assessment: la_assessment, date: @d5)

    @lists[gender] = Score::List.create!(name: "#{la_assessment.decorate} - Lauf 1", shortcut: 'Lauf 1',
                                         track_count: 3, assessments: [la_assessment], results: [sport_la, la])
  end

  def create_sport_teams
    [
      [:female, '1', 'Team Mecklenburg-Vorpommern', 'Team MV', 1, 2, 'MV'],
      [:female, '2', 'Team Brandenburg', 'Brandenburg', 1, 1869, 'BB'],
      [:female, '3', 'Thüringenauswahl', 'Thüringen', 1, 11, 'TH'],
      [:female, '4', 'Team Lausitz', 'Lausitz', 1, 3, 'BB'],
      [:female, '5', 'Sachsenauswahl', 'Sachsen', 1, 1842, 'SN'],
      [:female, '6', 'FF Taura', 'Taura', 1, 13, 'SN'],
      [:male, '1', 'Team Märkisch-Oderland', 'Team MOL', 1, 10, 'BB'],
      [:male, '2', 'Team Lausitz', 'Lausitz', 1, 3, 'BB'],
      [:male, '3', 'FF Gamstädt', 'Gamstädt', 1, 16, 'TH'],
      [:male, '4', 'FF Taura', 'Taura', 1, 13, 'SN'],
      [:male, '5', 'Team Mecklenburg-Vorpommern', 'Team MV', 1, 2, 'MV'],
      [:male, '6', 'Sachsenauswahl', 'Sachsen', 1, 1842, 'SN'],
      [:male, '7', 'Thüringenauswahl', 'Thüringen', 1, 11, 'TH'],
    ].each do |gender, lottery_number, name, shortcut, number, fss, federal_state|
      Team.create!(
        gender: gender,
        name: name,
        lottery_number: lottery_number,
        number: number,
        shortcut: shortcut,
        fire_sport_statistics_team_id: fss,
        federal_state: FederalState.find_by!(shortcut: federal_state),
        tag_references_attributes: [{ tag_id: @sport_tag.id }],
      )
    end
  end

  def create_la_teams
    [
      [:female, '1', 'FF Kittlitz', 'Kittlitz', 1, 415, 'BB'],
      [:female, '2', 'FF Tüttleben', 'Tüttleben', 1, 88, 'TH'],
      [:female, '3', 'FF Urbach', 'Urbach', 1, 2651, 'TH'],
      [:female, '4', 'Sachsenauswahl', 'Sachsen', 1, nil, 'SN'],
      [:female, '5', 'FF Beidendorf', 'Beidendorf', 1, 632, 'MV'],
      [:female, '6', 'Team Lausitz', 'Lausitz', 1, nil, 'BB'],
      [:female, '7', 'Perlen der Altmark', 'Altmark', 1, 2761, 'ST'],
      [:female, '8', 'FF Groß Lübbenau', 'Lübbenau', 1, 1260, 'BB'],
      [:female, '9', 'Team Mecklenburg-Vorpommern', 'Team MV', 1, nil, 'MV'],
      [:female, '10', 'Oberharz am Brocken', 'Oberharz', 1, 1210, 'ST'],
      [:female, '11', 'FF Crosta', 'Crosta', 1, 196, 'SN'],
      [:female, '12', 'Team Benndorf/Wiedemar', 'Wiedemar', 1, 3078, 'SN'],
      [:female, '13', 'Thüringenauswahl', 'Thüringen', 1, nil, 'TH'],
      [:female, '14', 'Team Brandenburg', 'Brandenburg', 1, nil, 'BB'],
      [:female, '15', 'FF Packebusch', 'Packebusch', 1, 903, 'ST'],
      [:female, '16', 'FF Gresse', 'Gresse', 1, 159, 'MV'],
      [:female, '17', 'Landkreis Rostock Nord', 'Team LRO', 1, 2349, 'MV'],
      [:female, '18', 'FF Zella', 'Zella', 1, 138, 'TH'],
      [:female, '19', 'FF Taura', 'Taura', 1, nil, 'SN'],
      [:female, '20', 'FF Marolterode', 'Marolterode', 1, 35, 'TH'],
      [:male, '1', 'FF Kummer', 'Kummer', 1, 491, 'MV'],
      [:male, '2', 'FF Gamstädt', 'Gamstädt', 1, nil, 'TH'],
      [:male, '3', 'FF Zella', 'Zella', 1, 138, 'TH'],
      [:male, '4', 'FF Zottelstedt', 'Zottelstedt', 1, 1706, 'TH'],
      [:male, '5', 'FF Stücken', 'Stücken', 1, 71, 'BB'],
      [:male, '6', 'Berlin', 'Berlin', 1, 7, 'BE'],
      [:male, '7', 'FF Beckwitz', 'Beckwitz', 1, 91, 'SN'],
      [:male, '8', 'FF Fahrendorf', 'Fahrendorf', 1, 192, 'ST'],
      [:male, '9', 'Berlin', 'Berlin', 2, 7, 'BE'],
      [:male, '10', 'Thüringenauswahl', 'Thüringen', 1, nil, 'TH'],
      [:male, '11', 'FF Taura', 'Taura', 1, nil, 'SN'],
      [:male, '12', 'FF Tryppehna', 'Tryppehna', 1, 438, 'ST'],
      [:male, '13', 'Team Lausitz', 'Lausitz', 1, nil, 'BB'],
      [:male, '14', 'FF Günthersdorf', 'Günthersdorf', 1, 778, 'BB'],
      [:male, '15', 'FF Niederalbertsdorf', 'Niederalb.', 1, 1560, 'SN'],
      [:male, '16', 'FF Brünn', 'Brünn', 1, 2003, 'TH'],
      [:male, '17', 'FF Niedersjesar', 'Niedersjesar', 1, nil, 'BB'],
      [:male, '18', 'FF Schwartow', 'Schwartow', 1, 2352, 'MV'],
      [:male, '19', 'FF Dürrhennersdorf', 'Dürrhenners.', 1, 210, 'SN'],
      [:male, '20', 'Sachsenauswahl', 'Sachsen', 1, nil, 'SN'],
      [:male, '21', 'Team Mecklenburg-Vorpommern', 'Team MV', 1, nil, 'MV'],
      [:male, '22', 'Team Märkisch-Oderland', 'Team MOL', 1, nil, 'BB'],
      [:male, '23', 'FF Hohen Viecheln', 'H. Viecheln', 1, 101, 'MV'],
      [:male, '24', 'Perlen der Altmark', 'P. Altmark', 1, 2761, 'ST'],
      [:male, '25', 'Berlin', 'Berlin', 3, 7, 'BE'],
      [:male, '26', 'FF Saalfeld', 'Saalfeld', 1, 1127, 'TH'],
    ].each do |gender, _lottery_number, name, shortcut, number, fss, federal_state|
      team = Team.find_by(gender: gender, shortcut: shortcut, number: number)
      team ||= Team.create!(
        disable_autocreate_assessment_requests: true,
        gender: gender,
        name: name,
        number: number,
        shortcut: shortcut,
        fire_sport_statistics_team_id: fss,
        federal_state: FederalState.find_by!(shortcut: federal_state),
      )

      list = @lists[gender]
      assessment = list.assessments.first
      team.requests.create(assessment: assessment, relay_count: 1) if team.requests.blank?

      run, track = list.next_free_track
      list.entries.create!(
        entity: team,
        run: run,
        track: track,
        assessment_type: :group_competitor,
        assessment: assessment,
      )
    end
  end
end
