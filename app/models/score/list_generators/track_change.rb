module Score
  class ListGenerators::TrackChange < ListGenerator
    validates :before_list, presence: true

    def self.to_label
      "Bahnwechsel"
    end

    def before_list= list_id
      @before_list_object = List.find(list_id)
      super(list_id)
    end

    def perform
      list.transaction do
        @before_list_object.entries.each do |entry|
          new_track = (entry.track % list.track_count) + 1
          list.entries.create!(
            entity: entry.entity,
            run: entry.run,
            track: new_track,
            assessment_type: entry.assessment_type
          )
        end
      end
    end
  end
end