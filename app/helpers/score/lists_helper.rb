module Score
  module ListsHelper
    def single_discipline?
      @score_list.assessment.discipline.single_discipline?
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

    def list_entry_options track, entry
      options = {}
      options[:class] = "next-run" if track == list_track_count
      options[:data] = { id: entry.id } if entry.present?
      options
    end

    def available_time_types_collection
      @available_time_types.map { |type| [t("result_time_types.#{type}"), type] }
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

    def result_for entry
      if entry && entry.result_type == "valid"
        entry.calculated_time.try(:second_time)
      elsif entry && entry.result_type == "invalid"
        "D"
      elsif entry && entry.result_type == "no-run"
        "N"
      else
        ""
      end
    end

    def form_generator_config_classes type
      ListGenerator.configuration.select { |key, types| type.in? types }.keys.join(" ")
    end

    def discipline_klass
      if single_discipline?
        Person
      elsif @score_list.assessment.fire_relay?
        TeamRelay
      else
        Team
      end
    end

    def not_yet_present_entities
      if @score_list.assessment.fire_relay?
        Team.all.map { |team| TeamRelay.create_next_free_for(team, @score_list.entries.pluck(:entity_id)) }
      else
        discipline_klass.where.not(id: @score_list.entries.pluck(:entity_id)) 
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

    def show_export_data(options={})
      header = ["Lauf", "Bahn"]
      if single_discipline?
        header.push("Vorname")
        header.push("Nachname")
      end
      header.push("Mannschaft")
      header.push("Zeit")
      if options[:stopwatch_times] == :all
        header.push("Elektronisch")
        header.push("Hand")
        header.push("Hand")
        header.push("Hand")
      end

      data = [header]
      score_list_entries do |entry, run, track|
        line = []
        if track == 1
          line.push(run)
        else
          line.push("")
        end

        line.push(track)
        if single_discipline?
          line.push(entry.try(:entity).try(:first_name))
          line.push(entry.try(:entity).try(:last_name))
          line.push(entry.try(:entity).try(:team_name, entry.try(:assessment_type)))
        else
          line.push(entry.try(:entity).try(:to_s))
        end
        line.push(result_for entry)
        if options[:stopwatch_times] == :all
          if entry.present?
            line.push(entry.stopwatch_times.where(type: ElectronicTime).first.try(:decorate).to_s)
            line.push(entry.stopwatch_times.where(type: HandheldTime).first.try(:decorate).to_s)
            line.push(entry.stopwatch_times.where(type: HandheldTime).second.try(:decorate).to_s)
            line.push(entry.stopwatch_times.where(type: HandheldTime).third.try(:decorate).to_s)
          else
            line.push("", "", "", "")
          end
        end
        data.push(line)
      end
      data
    end
  end
end
