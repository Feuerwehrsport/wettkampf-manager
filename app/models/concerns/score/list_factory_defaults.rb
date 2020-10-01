# frozen_string_literal: true

module Score::ListFactoryDefaults
  def possible_assessments
    Assessment.where(discipline: discipline)
  end

  def possible_results
    Score::Result.where(id: assessments.joins(:results).pluck('score_results.id'))
  end

  def possible_before_results
    Score::Result.where(id: assessments.joins(:results).pluck('score_results.id'))
  end

  def possible_before_lists
    Score::List.where(id: assessments.joins(:lists).pluck('score_lists.id'))
  end

  def default_shortcut
    shortcut.presence || begin
      if !discipline.like_fire_relay?
        "Lauf #{default_run}"
      else
        'Lauf'
      end
    end
  end

  def default_track_count
    track_count.presence || 2
  end

  def default_results
    results.presence || possible_results
  end

  def default_type
    type.presence || possible_types.first
  end

  def default_before_list
    before_list.presence || possible_before_lists.first
  end

  def default_before_result
    before_result.presence || possible_before_results.first
  end

  def default_best_count
    best_count.presence || 30
  end

  protected

  def default_main_name
    @default_main_name ||= assessments.count == 1 ? assessments.first.decorate.to_s : discipline.decorate.to_s
  end

  def default_run
    run = 1
    loop do
      break if Score::List.where(name: "#{default_main_name} - Lauf #{run}").blank?

      run += 1
    end
    run
  end
end
