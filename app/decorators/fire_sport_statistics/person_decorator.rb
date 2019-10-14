class FireSportStatistics::PersonDecorator < ApplicationDecorator
  def to_s
    full_name
  end

  def team_list
    teams.map(&:short).join(', ')
  end

  def personal_best_badge(current_result = nil)
    classes = %w[balloon best-badge]
    classes.push('personal-best') if new_personal_best?(current_result)
    h.content_tag(:span, 'i', class: classes, data: { balloon_content: h.render('people/best_badge', person: self) })
  end

  def personal_best_table
    @personal_best_table ||= begin
      table = {}
      %i[hb hl zk].each do |discipline|
        { personal_best: 'PB', saison_best: 'SB' }.each do |method, short|
          next if public_send(:"#{method}_#{discipline}").blank?

          table[discipline] ||= {}
          table[discipline][short] = [
            second_time(public_send(:"#{method}_#{discipline}")),
            public_send(:"#{method}_#{discipline}_competition"),
          ]
        end
      end
      table
    end
  end

  private

  def new_personal_best?(current_result)
    return false if current_result.blank?

    discipline = current_result.try(:list)&.discipline&.key || :zk
    best_time = public_send(:"personal_best_#{discipline}") || Firesport::INVALID_TIME
    best_time > current_result.compare_time
  end

  def second_time(time)
    return '' if time.blank? || time.zero?

    seconds = time.to_i / 100
    millis = time.to_i % 100
    "#{seconds},#{format('%02d', millis)} s"
  end
end
