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

    def score_list_entries
      entries = @score_list.entries.to_a
      track = 0
      run = 1
      entry = entries.shift
      invalid_count = 0
      while entry.present? || track != 0
        track += 1
        if entry && entry.track == track && entry.run == run
          yield entry, run, track
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
        entry.stopwatch_times.first.try(:second_time)
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
      single_discipline? ? Person : Team
    end

    def not_yet_present_entities
      discipline_klass.where.not(id: @score_list.entries.pluck(:entity_id)) 
    end
  end
end
