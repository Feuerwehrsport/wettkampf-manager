module DCup
  class SingleCompetitorResult < Struct.new(:id, :discipline_key, :gender, :youth)
    include Draper::Decoratable

    def self.all
      [
        [:hb, :female, false],
        [:hb, :male, false],
        [:hb, :female, true],
        [:hb, :male, true],
        [:hl, :female, false],
        [:hl, :male, false],
        [:hl, :female, true],
        [:hl, :male, true],
        [:zk, :female, false],
        [:zk, :male, false],
        [:zk, :female, true],
        [:zk, :male, true],
      ].each_with_index.map { |args, id| new(id + 1, *args) }
    end

    def self.find(id)
      all.find { |element| element.id.to_s == id.to_s }
    end

    def assessment
      @assessment ||= begin
        class_name = Discipline.types_with_key[discipline_key]
        Assessment.gender(gender).joins(:discipline).where(disciplines: { type: class_name.to_s }).first!
      end
    end

    def rows
      @rows ||= calculate_rows
    end

    def competitions
      calculate_rows if @competitions.nil?
      @competitions
    end

    def calculate_rows
      competitions = {}
      result = FireSportStatistics::DCupResult.gender(gender).where(discipline_key: discipline_key, youth: youth).first
      people = {}
      FireSportStatistics::DCupSingleResult.where(result: result).each do |result|
        competitions[result.competition_id] ||= result.competition
        people[result.person_id] ||= SingleCompetitorResultRow.new(result.person)
        people[result.person_id].add_result(result)
      end
      @competitions = competitions.values.sort_by(&:date)
      people.values.sort
    end

    def today_result
      Score::Result.where(assessment: assessment, youth: youth).first!
    end
  end
end