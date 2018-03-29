class Preset
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :id
  alias to_param id

  def self.preset_classes
    [
      Presets::Nothing,
      Presets::FireAttack,
      Presets::DCupFull,
      Presets::DCupSmall,
      Presets::HallCup,
      Presets::MvCupSingle,
      Presets::BrandenburgJugend,
      Presets::Sonnenwalde,
      Presets::DM,
      Presets::LandesmeisterschaftBrandenburg2017,
    ]
  end

  def self.all
    preset_classes.each_with_index.map { |klass, id| klass.new(id: (id + 1)) }
  end

  def self.find(id)
    all.find { |preset| preset.id == id.to_i } || raise(ActiveRecord::RecordNotFound)
  end

  def save
    ActiveRecord::Base.transaction do
      perform
      Competition.one.update!(configured: true)
    end
  end

  protected

  def perform; end

  private

  def dcup_seed(all_disciplines = true)
    Competition.update_all(
      group_score_count: 4,
      group_assessment: true,
      competition_result_type: 'dcup',
    )
    youth_tag = PersonTag.create!(name: 'U20', competition: Competition.first)

    @hb = Disciplines::ObstacleCourse.create!
    @hl = Disciplines::ClimbingHookLadder.create!
    @gs = Disciplines::GroupRelay.create!
    @fs = Disciplines::FireRelay.create!(like_fire_relay: true) if all_disciplines
    @zk = Disciplines::DoubleEvent.create!
    @la = Disciplines::FireAttack.create!

    competition_results = %i[female male].map do |gender|
      competition_result = Score::CompetitionResult.create(gender: gender, result_type: 'dcup', name: 'D-Cup')

      zk_assessment = Assessment.create!(discipline: @zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)
      zk_result.update!(series_assessments: [zk_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').find { |a| !a.name.include?('U20') }].compact)
      zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment, tag_references_attributes: [{ tag_id: youth_tag.id }])
      zk_result_youth.update!(series_assessments: [zk_result_youth.possible_series_assessments.year(Date.current.year).round_name('D-Cup').find { |a| a.name.include?('U20') }].compact)

      hb_assessment = Assessment.create!(discipline: @hb, gender: gender, score_competition_result: competition_result)
      hb_result = Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)
      hb_result.update!(series_assessments: [hb_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').find { |a| !a.name.include?('U20') }, hb_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').first].compact)
      hb_u20_result = Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result_youth, tag_references_attributes: [{ tag_id: youth_tag.id }])
      hb_u20_result.update!(series_assessments: [hb_u20_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').find { |a| a.name.include?('U20') }].compact)

      hl_assessment = Assessment.create!(discipline: @hl, gender: gender, score_competition_result: competition_result)
      hl_result = Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)
      hl_result.update!(series_assessments: [hl_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').find { |a| !a.name.include?('U20') }, hl_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').first].compact)
      hl_u20_result = Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result_youth, tag_references_attributes: [{ tag_id: youth_tag.id }])
      hl_u20_result.update!(series_assessments: [hl_u20_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').find { |a| a.name.include?('U20') }].compact)

      la_assessment = Assessment.create!(discipline: @la, gender: gender, score_competition_result: competition_result)
      la_result = Score::Result.create!(assessment: la_assessment, group_assessment: true)
      la_result.update!(series_assessments: [la_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').first].compact)

      if all_disciplines
        fs_assessment = Assessment.create!(discipline: @fs, gender: gender, score_competition_result: competition_result)
        fs_result = Score::Result.create!(assessment: fs_assessment, group_assessment: true)
        fs_result.update!(series_assessments: [fs_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').first].compact)
      end

      competition_result
    end

    gs_assessment = Assessment.create!(discipline: @gs, gender: :female, score_competition_result: competition_results.first)
    gs_result = Score::Result.create!(assessment: gs_assessment, group_assessment: true)
    gs_result.update!(series_assessments: [gs_result.possible_series_assessments.year(Date.current.year).round_name('D-Cup').first].compact)
  end
end
