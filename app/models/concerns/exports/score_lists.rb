# frozen_string_literal: true

module Exports::ScoreLists
  def show_export_data(list, more_columns: false, double_run: false, pdf: false, hint_size: 6,
                       show_bib_numbers: Competition.one.show_bib_numbers?, separate_target_times_as_columns: false)
    data = [show_export_header(list, more_columns: more_columns, double_run: double_run,
                                     show_bib_numbers: show_bib_numbers,
                                     separate_target_times_as_columns: separate_target_times_as_columns)]

    score_list_entries(list) do |entry, run, track, _best_of_run|
      line = []
      line.push((track == 1 ? run : ''), track)
      if list.single_discipline?
        line.push(entry.try(:entity).try(:bib_number).to_s) if show_bib_numbers

        line.push(entry.try(:entity).try(:export_last_name, list, pdf: pdf, hint_size: hint_size) || '')
        line.push(entry.try(:entity).try(:short_first_name).to_s)
        team_name = entry.try(:entity).try(:team_shortcut_name, entry.try(:assessment_type))
        team_name = append_assessment(list, entry, team_name, pdf: pdf, hint_size: hint_size)
      else
        team_name = entry.try(:entity).to_s
        team_name = append_assessment(list, entry, team_name, pdf: pdf, hint_size: hint_size)

        tags = (entry.try(:entity).try(:tag_names) || []) & list.tag_names
        team_name += "<font size='6'> #{tags.join(',')}</font>" if tags.present?

        if Competition.one.federal_states?
          federal_state_shortcut = entry.try(:entity).try(:federal_state).try(:shortcut)
          if federal_state_shortcut.present?
            team_name += "<font size='#{hint_size}'> <i>#{federal_state_shortcut}</i></font>"
          end
        end
      end
      if pdf
        line.push(content: team_name, inline_format: true)
      else
        line.push(team_name)
      end

      if list.separate_target_times?
        if separate_target_times_as_columns
          line.push(entry&.second_time_left_target, entry&.second_time_right_target)
        else
          line.push(entry&.target_times_as_data(pdf: pdf, hint_size: hint_size))
        end
      end
      line.push(entry.try(:human_time))
      line.push('', '') if more_columns
      line.push('') if double_run
      data.push(line)
    end
    data
  end

  def show_export_header(list, more_columns:, double_run:, show_bib_numbers:, separate_target_times_as_columns:)
    header = %w[Lauf Bahn]
    if list.single_discipline?
      header.push('Nr.') if show_bib_numbers
      header.push('Nachname', 'Vorname')
    end
    header.push('Mannschaft')
    if more_columns
      header.push('', '', '')
    elsif double_run
      header.push('Lauf 1', 'Lauf 2')
    else
      if list.separate_target_times?
        if separate_target_times_as_columns
          header.push('Links', 'Rechts')
        else
          header.push('Ziele')
        end
      end
      header.push('Zeit')
    end
    header
  end

  def score_list_entries(list, move_modus = false)
    entries = if list.errors.present?
                list.entries.to_a
              else
                list.entries.includes(:entity).to_a
              end
    best_of_runs = list.show_best_of_run? ? calculate_best_of_runs(entries) : {}
    track = 0
    run = 1
    entry = entries.shift
    invalid_count = 0
    extra_run = move_modus
    while entry.present? || track != 0 || extra_run
      extra_run = false if entry.blank? && track.zero? && extra_run
      track += 1
      if entry && entry.track == track && entry.run == run
        yield entry.decorate, run, track, entry.in?(best_of_runs[run] || [])
        entry = entries.shift
      else
        yield nil, run, track, false
      end

      if track == list.track_count
        track = 0
        run += 1
      end

      invalid_count += 1
      return if invalid_count > 1000
    end
  end

  def calculate_best_of_runs(entries)
    entries.select(&:result_valid?).group_by(&:run).map do |run, runners|
      best_per_assessments = runners.group_by(&:assessment_id).map do |_, ass_runners|
        ass_runners.group_by(&:time).min.second
      end
      [run, best_per_assessments.inject(:+)]
    end.to_h
  end

  def append_assessment(list, entry, team_name, pdf:, hint_size: 6)
    if list.show_multiple_assessments? && list.multiple_assessments? && entry.present?
      team_name += if pdf
                     "<font size='#{hint_size}'> (#{entry&.assessment&.decorate})</font>"
                   else
                     " (#{entry&.assessment&.decorate})"
                   end
    end
    team_name
  end

  def size7(content, inline_format)
    if inline_format
      { content: "<font size='7'>#{content}</font>", inline_format: true }
    else
      content
    end
  end
end
