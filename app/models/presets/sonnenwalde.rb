class Presets::Sonnenwalde < Preset
  def name
    'Stadtmeisterschaften Sonnewalde 07.07.2018'
  end

  def description_items
    [
      'Löschangriff Bambinis (6-10 Jahre)',
      'Löschangriff AK I (10-14 Jahre) weiblich/männlich',
      'Löschangriff AK II (15-18 Jahre) weiblich/männlich',
      'Löschangriff Frauen ',
      'Löschangriff Männer (Vorlauf + Endlauf für die Besten 8)',
      'Löschangriff Frauen Ü40',
      'Löschangriff Männer Ü40',
    ]
  end

  protected

  def perform
    Competition.update_all(
      name: 'Stadtmeisterschaften Sonnewalde',
      place: 'Sonnewalde',
      date: Date.parse('2018-07-07'),
    )

    la = Disciplines::FireAttack.create!

    %i[female male].map do |gender|
      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      la_assessment = Assessment.create!(discipline: la, gender: gender,
                                         name: "Löschangriff - #{I18n.t("gender.#{gender}")} - Ü40")
      Score::Result.create!(assessment: la_assessment, group_assessment: true)
    end

    # Löschangriff
    fire_attack = Disciplines::FireAttack.create!(name: 'Löschangriff Bambinis', short_name: 'LA B')
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: 'Löschangriff Bambinis')
    Score::Result.create!(assessment: assessment)

    fire_attack = Disciplines::FireAttack.create!(name: 'Löschangriff Jugend', short_name: 'LA J')
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: 'AK1 Löschangriff Mädchen')
    Score::Result.create!(assessment: assessment)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: 'AK1 Löschangriff Jungen')
    Score::Result.create!(assessment: assessment)
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: 'AK2 Löschangriff Mädchen')
    Score::Result.create!(assessment: assessment)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: 'AK2 Löschangriff Jungen')
    Score::Result.create!(assessment: assessment)
  end
end
