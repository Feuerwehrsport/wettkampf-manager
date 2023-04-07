# frozen_string_literal: true

module Presets::DcupSupport
  protected

  def dcup_seed(all_disciplines = true)
    @all_disciplines = all_disciplines
    Competition.update_all(
      group_score_count: 4,
      group_assessment: true,
      competition_result_type: 'dcup',
    )
    @youth_tag = PersonTag.create!(name: 'U20', competition: Competition.first)

    @hb = Disciplines::ObstacleCourse.create!
    @hl = Disciplines::ClimbingHookLadder.create!
    @gs = Disciplines::GroupRelay.create!
    @fs = Disciplines::FireRelay.create!(like_fire_relay: true) if all_disciplines
    @zk = Disciplines::DoubleEvent.create!
    @la = Disciplines::FireAttack.create!

    { indifferent: 'AK 1', female: 'AK 2 - Mädchen', male: 'AK 2 - Jungen' }.each do |gender, name|
      band = Band.create!(gender: gender, name: name)

      hb_assessment = Assessment.create!(discipline: @hb, band: band)
      Score::Result.create!(assessment: hb_assessment, group_assessment: false)

      hl_assessment = Assessment.create!(discipline: @hl, band: band)
      Score::Result.create!(assessment: hl_assessment, group_assessment: false)
    end

    competition_results = { female: 'Frauen', male: 'Männer' }.map do |gender, name|
      band = Band.create!(gender: gender, name: name)
      for_band(band)
    end

    gs_assessment = Assessment.create!(discipline: @gs, band: competition_results.first.band,
                                       score_competition_result: competition_results.first)
    gs_result = Score::Result.create!(assessment: gs_assessment, group_assessment: true)
    gs_result.update!(series_assessments: series(gs_result))
  end

  def for_band(band)
    competition_result = Score::CompetitionResult.create(band: band, result_type: 'dcup', name: 'D-Cup')

    zk_assessment = Assessment.create!(discipline: @zk, band: band)
    zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)
    zk_result.update!(series_assessments: series(zk_result, false))
    zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment,
                                                       tag_references_attributes: [{ tag_id: @youth_tag.id }])
    zk_result_youth.update!(series_assessments: series(zk_result_youth, true))

    hb_assessment = Assessment.create!(discipline: @hb, band: band, score_competition_result: competition_result)
    hb_result = Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)
    hb_result.update!(series_assessments: series(hb_result, false) + series(hb_result))
    hb_u20_result = Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result_youth,
                                          tag_references_attributes: [{ tag_id: @youth_tag.id }])
    hb_u20_result.update!(series_assessments: series(hb_u20_result, true))

    hl_assessment = Assessment.create!(discipline: @hl, band: band, score_competition_result: competition_result)
    hl_result = Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)
    hl_result.update!(series_assessments: series(hl_result, false) + series(hl_result))
    hl_u20_result = Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result_youth,
                                          tag_references_attributes: [{ tag_id: @youth_tag.id }])
    hl_u20_result.update!(series_assessments: series(hl_u20_result, true))

    la_assessment = Assessment.create!(discipline: @la, band: band, score_competition_result: competition_result)
    la_result = Score::Result.create!(assessment: la_assessment, group_assessment: true)
    la_result.update!(series_assessments: series(la_result))

    if @all_disciplines
      fs_assessment = Assessment.create!(discipline: @fs, band: band, score_competition_result: competition_result)
      fs_result = Score::Result.create!(assessment: fs_assessment, group_assessment: true)
      fs_result.update!(series_assessments: series(fs_result))
    end

    competition_result
  end

  def series(result, u20 = nil)
    if u20.nil?
      super(result, 'D-Cup')
    elsif u20
      super(result, 'D-Cup', name_part: 'U20')
    else
      super(result, 'D-Cup', not_name_part: 'U20')
    end
  end
end
