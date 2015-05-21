require 'score'

module Score
  class Result < ActiveRecord::Base
    belongs_to :assessment
    belongs_to :double_event_result
    has_many :lists

    validates :assessment, presence: true

    def to_label
      decorate.to_s
    end

    def rows
      @rows ||= generate_rows.sort
    end

    def generate_rows
      rows = {}
      lists.each do |list|
        list.entries.not_waiting.each do |list_entry|
          if rows[list_entry.entity.id].nil?
            rows[list_entry.entity.id] = ResultRow.new(list_entry.entity, self)
          end
          rows[list_entry.entity.id].add_list(list_entry)
        end
      end
      rows.values
    end
  end
end
