class Presets::Sonnenwalde < Preset
  def name
    'Stadtmeisterschaften Sonnewalde 2015'
  end

  def description_items
    [
      'Frauen: Gruppenstaffete, 4x100m Feuerwehrstaffette, 100m Hindernisbahn, Hakenleitersteigen, Löschangriff Nass; Ü40 Löschangriff Nass',
      'Männer: 4x100m Feuerwehrstaffette, 100m Hindernisbahn, Hakenleitersteigen, Löschangriff Nass, Ü40 Löschangriff Nass',
      'Kinder jeweils m/w und AKI AKII: Gruppenstaffete, 5x80m Feuerwehrstaffette, Löschangriff Nass',
      'Kinder AKI 10-12; AKI 13-14; AKII 15-16; AKII 17-18 jeweils m/w: 100m Hindernisbahn, Hakenleitersteigen',
    ]
  end

  protected

  def perform
    Competition.update_all(
      name: 'Stadtmeisterschaften Sonnewalde',
      place: 'Sonnewalde',
      date: Date.parse('2015-07-04'),
      group_assessment: true,
      competition_result_type: '',
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    gs = Disciplines::GroupRelay.create!
    fs = Disciplines::FireRelay.create!(like_fire_relay: true)
    zk = Disciplines::DoubleEvent.create!
    la = Disciplines::FireAttack.create!

    %i[female male].map do |gender|
      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)

      hl_assessment = Assessment.create!(discipline: hl, gender: gender)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)

      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      la_assessment = Assessment.create!(discipline: la, gender: gender, name: "Löschangriff - #{I18n.t("gender.#{gender}")} - Ü40")
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      fs_assessment = Assessment.create!(discipline: fs, gender: gender)
      Score::Result.create!(assessment: fs_assessment, group_assessment: true)
    end

    gs_assessment = Assessment.create!(discipline: gs, gender: :female)
    Score::Result.create!(assessment: gs_assessment, group_assessment: true)

    # Gruppenstafette
    group_relay = Disciplines::GroupRelay.create!(name: 'Gruppenstafette Jugend', short_name: 'GS J')
    assessment = Assessment.create!(discipline: group_relay, gender: :female, name: 'AK1 Gruppenstafette Mädchen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :male, name: 'AK1 Gruppenstafette Jungen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :female, name: 'AK2 Gruppenstafette Mädchen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :male, name: 'AK2 Gruppenstafette Jungen')
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # 5x80 Meter-Staffel
    fire_relay = Disciplines::FireRelay.create!(name: '5x80-Meter-Staffel', short_name: '5x80')
    assessment = Assessment.create!(discipline: fire_relay, gender: :female, name: 'AK1 Staffel Mädchen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :male, name: 'AK1 Staffel Jungen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :female, name: 'AK2 Staffel Mädchen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :male, name: 'AK2 Staffel Jungen')
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # Löschangriff
    fire_attack = Disciplines::FireAttack.create!(name: 'Löschangriff Jugend', short_name: 'LA J')
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: 'AK1 Löschangriff Mädchen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: 'AK1 Löschangriff Jungen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: 'AK2 Löschangriff Mädchen')
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: 'AK2 Löschangriff Jungen')
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # Hakenleitersteigen
    chl = Disciplines::ClimbingHookLadder.create!
    # Hindernisbahn
    oc = Disciplines::ObstacleCourse.create!
    [
      [:female, 'AK1 10-12 DIS Mädchen'],
      [:female, 'AK1 13-14 DIS Mädchen'],
      [:male, 'AK1 10-12 DIS Jungen'],
      [:male, 'AK1 13-14 DIS Jungen'],
      [:female, 'AK2 15-16 DIS Mädchen'],
      [:female, 'AK2 17-18 DIS Mädchen'],
      [:male, 'AK2 15-16 DIS Jungen'],
      [:male, 'AK2 17-18 DIS Jungen'],
    ].each do |ak|
      assessment = Assessment.create!(discipline: chl, gender: ak.first, name: ak.last.gsub('DIS', 'Hakenleitersteigen'))
      Score::Result.create!(assessment: assessment)
      assessment = Assessment.create!(discipline: oc, gender: ak.first, name: ak.last.gsub('DIS', 'Hindernisbahn'))
      Score::Result.create!(assessment: assessment)
    end
  end
end
