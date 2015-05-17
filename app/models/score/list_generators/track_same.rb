module Score
  class ListGenerators::TrackSame < ListGenerator
    validates :before_list, presence: true

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
  end
end