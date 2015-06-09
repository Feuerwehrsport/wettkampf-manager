module Score
  class ListGenerators::TrackSame < ListGenerator
    validates :before_list, presence: true
    validate :before_list_assessment_match

    def self.to_label
      "Bahn behalten"
    end

    def before_list= list_id
      @before_list_object = List.find(list_id)
      super(list_id)
    end

    def perform
      list.transaction do
        @before_list_object.entries.each do |entry|
          list.entries.create!(
            entity: entry.entity,
            run: entry.run,
            track: entry.track,
            assessment_type: entry.assessment_type
          )
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