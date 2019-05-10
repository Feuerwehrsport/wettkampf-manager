class Presets::SonnenwaldeKreisausscheid < Preset
  def name
    'Stadtmeisterschaften Sonnewalde / Kreismeisterschaft Elbe Elster 11.05.2019'
  end

  def description_items
    [
      'Löschangriff Bambinis (6-10 Jahre)',
      'Kinder 10-14; 15-18 jeweils m/w: Gruppenstaffete, 5x80m Feuerwehrstaffette, Löschangriff Nass, 100m Hindernisbahn, Hakenleitersteigen',
      'Stadtmeisterschaft Frauen/Männer Gruppenstaffete, 4x100m Feuerwehrstaffette, Löschangriff Nass, 100m Hindernisbahn, Hakenleitersteigen',
      'Stadtmeisterschaft Löschangriff Frauen/Männer Ü40',
      'Kreismeisterschaft Frauen/Männer Gruppenstaffete, 4x100m Feuerwehrstaffette, Löschangriff Nass, 100m Hindernisbahn, Hakenleitersteigen, Zweikampf',
    ]
  end

  protected

  def perform
    Competition.update_all(
      name: 'Kreismeisterschaft Elbe Elster - Stadtmeisterschaften Sonnewalde',
      place: 'Doberlug-Kirchhain',
      date: Date.parse('2019-05-11'),
      group_score_count: 3,
      group_run_count: 4,
    )

    fire_attack = Disciplines::FireAttack.create!(name: 'Löschangriff Bambinis', short_name: 'LA B')
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: 'Löschangriff Bambinis')
    Score::Result.create!(assessment: assessment, date: Date.parse('2019-05-12'))

    group_relay = Disciplines::GroupRelay.create!(name: 'Gruppenstafette Jugend', short_name: 'GS')
    fire_relay = Disciplines::FireRelay.create!(name: '5x80-Meter-Staffel', short_name: '5x80')
    fire_attack = Disciplines::FireAttack.create!(name: 'Löschangriff Jugend', short_name: 'LA J')
    hl = Disciplines::ClimbingHookLadder.create!
    hb = Disciplines::ObstacleCourse.create!

    {
      'AK1 Mädchen' => :female,
      'AK2 Mädchen' => :female,
      'AK1 Jungen' => :male,
      'AK2 Jungen' => :male,
    }.each do |name, gender|
      assessment = Assessment.create!(discipline: fire_attack, gender: gender, name: "Löschangriff #{name}")
      Score::Result.create!(assessment: assessment, date: Date.parse('2019-05-12'))
      assessment = Assessment.create!(discipline: fire_relay, gender: gender, name: "5x80-Meter-Staffel #{name}")
      Score::Result.create!(assessment: assessment)
      assessment = Assessment.create!(discipline: group_relay, gender: gender, name: "Gruppenstafette #{name}")
      Score::Result.create!(assessment: assessment)
      assessment = Assessment.create!(discipline: hl, gender: gender, name: "Hakenleitersteigen #{name}")
      Score::Result.create!(assessment: assessment)
      assessment = Assessment.create!(discipline: hb, gender: gender, name: "Hindernisbahn #{name}")
      Score::Result.create!(assessment: assessment)
    end

    kreis_person_tag = PersonTag.create!(name: 'Kreis', competition: Competition.first)
    stadt_person_tag = PersonTag.create!(name: 'Stadt', competition: Competition.first)
    kreis_team_tag = TeamTag.create!(name: 'Kreis', competition: Competition.first)
    stadt_team_tag = TeamTag.create!(name: 'Stadt', competition: Competition.first)

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    gs = Disciplines::GroupRelay.create!
    fs = Disciplines::FireRelay.create!(like_fire_relay: true)
    la = Disciplines::FireAttack.create!
    zk = Disciplines::DoubleEvent.create!

    %i[female male].map do |gender|
      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, tag_references_attributes: [{ tag_id: kreis_person_tag.id }], double_event_result: zk_result)
      Score::Result.create!(assessment: hb_assessment, tag_references_attributes: [{ tag_id: stadt_person_tag.id }])

      hl_assessment = Assessment.create!(discipline: hl, gender: gender)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, tag_references_attributes: [{ tag_id: kreis_person_tag.id }], double_event_result: zk_result)
      Score::Result.create!(assessment: hl_assessment, tag_references_attributes: [{ tag_id: stadt_person_tag.id }])

      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment, tag_references_attributes: [{ tag_id: kreis_team_tag.id }])
      Score::Result.create!(assessment: la_assessment, tag_references_attributes: [{ tag_id: stadt_team_tag.id }], date: Date.parse('2019-05-12'))
      la_assessment40 = Assessment.create!(discipline: la, gender: gender, name: "Löschangriff - #{I18n.t("gender.#{gender}")} - Ü40")
      Score::Result.create!(assessment: la_assessment40)

      fs_assessment = Assessment.create!(discipline: fs, gender: gender)
      Score::Result.create!(assessment: fs_assessment, tag_references_attributes: [{ tag_id: kreis_team_tag.id }])
      Score::Result.create!(assessment: fs_assessment, tag_references_attributes: [{ tag_id: stadt_team_tag.id }])

      gs_assessment = Assessment.create!(discipline: gs, gender: gender)
      Score::Result.create!(assessment: gs_assessment, tag_references_attributes: [{ tag_id: kreis_team_tag.id }])
      Score::Result.create!(assessment: gs_assessment, tag_references_attributes: [{ tag_id: stadt_team_tag.id }])
    end
  end
end
