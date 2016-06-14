module Score::ListsHelper
  def single_discipline?
    @score_list.assessments.first.discipline.single_discipline?
  end

  def list_track_count
    @score_list.track_count
  end

  def pdf_row_colors
    color = 264
    (1..list_track_count).map do
      color -= 9
      color.to_s(16) * 3
    end
  end

  def multiple_assessments?
    @score_list.assessments.count > 1
  end

  def list_entry_options track, entry
    options = {}
    options[:class] = "next-run" if track == list_track_count
    options[:data] = { id: entry.id } if entry.present?
    options
  end

  def score_list_entries(move_modus=false)
    entries = @score_list.entries.includes(:entity).to_a
    track = 0
    run = 1
    entry = entries.shift
    invalid_count = 0
    extra_run = move_modus
    while entry.present? || track != 0 || extra_run
      if entry.blank? && track == 0 && extra_run
        extra_run = false
      end
      track += 1
      if entry && entry.track == track && entry.run == run
        yield entry.decorate, run, track
        entry = entries.shift
      else
        yield nil, run, track
      end
      
      if track == list_track_count
        track = 0
        run += 1
      end

      invalid_count += 1
      return if invalid_count > 1000
    end
  end

  def discipline_klass
    if single_discipline?
      Person
    elsif @score_list.assessments.first.fire_relay?
      TeamRelay
    else
      Team
    end
  end

  def not_yet_present_entities
    if @score_list.assessments.first.fire_relay?
      Team.all.map { |team| TeamRelay.create_next_free_for(team, @score_list.entries.pluck(:entity_id)) }
    else
      discipline_klass.where.not(id: @score_list.entries.pluck(:entity_id)).sort_by { |e| label_method_for_select_entity(e) }
    end
  end

  def label_method_for_select_entity entity
    decorated = entity.decorate
    if single_discipline?
      "#{decorated.full_name} #{decorated.translated_gender}"
    else
      decorated.numbered_name_with_gender
    end
  end

  def preset_value_for(field, value)
    @score_list.send(field).blank? ? { value: value } : {}
  end

  def show_export_data
    header = ['Lauf', 'Bahn']
    if single_discipline?
      header.push('Nr.') if Competition.one.show_bib_numbers?
      header.push('Vorname', 'Nachname')
    end
    header.push('Mannschaft')
    if params[:more_columns].present?
      header.push('', '', '')
    else
      header.push('Zeit')
    end

    data = [header]

    score_list_entries do |entry, run, track|
      line = []
      line.push((track == 1 ? run : ''), track)
      if single_discipline?
        line.push(entry.try(:entity).try(:bib_number)) if Competition.one.show_bib_numbers?
        line.push(entry.try(:entity).try(:short_first_name), entry.try(:entity).try(:short_last_name))
        line.push(entry.try(:entity).try(:team_shortcut_name, entry.try(:assessment_type)))
      else
        team_name = entry.try(:entity).to_s
        team_name += " <font size='6'>(#{entry.try(:assessment).try(:decorate)})</font>" if multiple_assessments? && entry.present?
        line.push(content: team_name, inline_format: true)
      end
      line.push(entry.try(:human_time))
      line.push('', '') if params[:more_columns].present?
      data.push(line)
    end
    data
  end
end
