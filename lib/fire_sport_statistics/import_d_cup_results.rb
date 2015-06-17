module FireSportStatistics
  class ImportDCupResults
    def initialize(verbose = false)
      @verbose = verbose

      ActiveRecord::Base.transaction do
        DCupResult.destroy_all
        DCupSingleResult.destroy_all
        Competition.destroy_all

        results = {}

        API::Get.dcup_single_results["results"].each do |full_key, single_results|
          single_results.each do |single_result|
            DCupSingleResult.create!(
              result: result(full_key),
              person: person(single_result["person_id"]),
              competition: competition(single_result["competition_id"]),
              points: single_result["points"],
              time: single_result["time"],
            )
            verbose_dot "."
          end
        end
      end
    end

    def result(full_key)
      @results ||= {}
      return @results[full_key] if @results[full_key].present?

      /^(?<discipline_key>[hz][lbk])-(?<gender>(fe)?male)(?<youth>-youth)?$/ =~ full_key
      @results[full_key] = DCupResult.create!(
        discipline_key: discipline_key,
        gender: gender,
        youth: youth.present?,
      )
    end

    def person(external_id)
      Person.find_by_external_id!(external_id)
    end

    def competition(external_id)
      @competitions ||= {}
      return @competitions[external_id] if @competitions[external_id].present?
      @competitions[external_id] = create_competition(external_id)
    end

    def create_competition(external_id)
      @all_competitions ||= API::Get.competitions
      competition = @all_competitions.find { |c| c.id == external_id }
      Competition.create!(
        name: [competition.name, competition.place].reject(&:blank?).join(" - "),
        date: Date.parse(competition.date),
        external_id: external_id,
      )
    end

    def verbose_dot char
      print char if @verbose
    end
  end
end