# frozen_string_literal: true

class Presets::BrandenburgJugend < Preset
  def name
    'Brandenburg - Jugend'
  end

  def description_items
    [
      'Kinder 10-14; 15-18 jeweils m/w: Gruppenstaffete, 5x80m Feuerwehrstaffette, Löschangriff Nass',
      'Kinder 10-14; 15-16; 17-18 jeweils m/w: 100m Hindernisbahn, Hakenleitersteigen',
    ]
  end

  protected

  def perform
    Competition.update_all(
      name: 'Jugendfeuerwehr Brandenburg',
      place: 'Brandenburg',
      date: Date.parse('2017-01-01'),
      group_assessment: true,
      competition_result_type: :places_to_points,
    )

    group_relay = Disciplines::GroupRelay.create!(name: 'Gruppenstafette Jugend', short_name: 'GS')
    fire_relay = Disciplines::FireRelay.create!(name: '5x80-Meter-Staffel', short_name: '5x80')
    fire_attack = Disciplines::FireAttack.create!(name: 'Löschangriff Jugend', short_name: 'LA')

    {
      'Mädchen 10-14' => :female,
      'Mädchen 15-18' => :female,
      'Jungen 10-14' => :male,
      'Jungen 15-18' => :male,
    }.each do |name, gender|
      competition_result = Score::CompetitionResult.create!(gender: gender, result_type: :places_to_points, name: name)
      assessment = Assessment.create!(discipline: group_relay, gender: gender, name: "Gruppenstafette #{name}",
                                      score_competition_result: competition_result)
      Score::Result.create!(assessment: assessment, group_assessment: true)

      assessment = Assessment.create!(discipline: fire_relay, gender: gender, name: "5x80-Meter-Staffel #{name}",
                                      score_competition_result: competition_result)
      Score::Result.create!(assessment: assessment, group_assessment: true)

      assessment = Assessment.create!(discipline: fire_attack, gender: gender, name: "Löschangriff #{name}",
                                      score_competition_result: competition_result)
      Score::Result.create!(assessment: assessment, group_assessment: true)
    end

    hl = Disciplines::ClimbingHookLadder.create!
    hb = Disciplines::ObstacleCourse.create!
    {
      'Mädchen 10-14' => :female,
      'Mädchen 15-16' => :female,
      'Mädchen 17-18' => :female,
      'Jungen 10-14' => :male,
      'Jungen 15-16' => :male,
      'Jungen 17-18' => :male,
    }.each do |name, gender|
      assessment = Assessment.create!(discipline: hl, gender: gender, name: "Hakenleitersteigen #{name}")
      Score::Result.create!(assessment: assessment)
      assessment = Assessment.create!(discipline: hb, gender: gender, name: "Hindernisbahn #{name}")
      Score::Result.create!(assessment: assessment)
    end
  end
end
