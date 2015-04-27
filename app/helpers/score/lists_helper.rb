module Score
  module ListsHelper
    def single_discipline?
      @score_list.assessment.discipline.single_discipline?
    end

    def list_track_count
      @score_list.track_count
    end

    def list_entry_options track, entry
      options = {}
      options[:class] = "next-run" if track == list_track_count
      options[:data] = { id: entry.id } if entry.present?
      options
    end


    def score_list_entries
      entries = @score_list.entries.to_a
      track = 0
      run = 1
      entry = entries.shift
      invalid_count = 0
      while entries.length > 0 || track != 0
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
      if entry.result_type == "valid"
        entry.stopwatch_times.first.try(:second_time)
      elsif entry.result_type == "invalid"
        "D"
      elsif entry.result_type == "no-run"
        "N"
      else
        ""
      end
    end
  end
end
