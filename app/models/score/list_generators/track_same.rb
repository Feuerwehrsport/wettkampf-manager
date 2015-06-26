module Score
  class ListGenerators::TrackSame < ListGenerator
    validates :before_list, presence: true
    validate :before_list_assessments_match

    def before_list= list_id
      @before_list_object = List.find(list_id)
      super(list_id)
    end

    def perform
      list.transaction do
        @before_list_object.entries.each do |entry|
          create_list_entry(entry, entry.run, entry.track)
        end
      end
    end

    private

    def before_list_assessments_match
      if @before_list_object.blank? || @before_list_object.assessment_ids.sort != list.assessment_ids.sort
        errors.add(:before_list, "muss mit jetziger Wertungsgruppe übereinstimmen")
      end
    end
  end
end