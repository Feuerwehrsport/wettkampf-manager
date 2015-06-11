module Score
  class ListGenerators::TrackChange < ListGenerator
    validates :before_list, presence: true
    validate :before_list_assessment_match

    def before_list= list_id
      @before_list_object = List.find_by_id(list_id)
      super(list_id)
    end

    def perform
      list.transaction do
        @before_list_object.entries.each do |entry|
          new_track = (entry.track % list.track_count) + 1
          create_list_entry(entry, entry.run, new_track)
        end
      end
    end

    private

    def before_list_assessment_match
      if @before_list_object.present? && @before_list_object.assessment != list.assessment
        errors.add(:before_list, "muss mit jetziger Wertungsgruppe übereinstimmen")
      end
    end
  end
end