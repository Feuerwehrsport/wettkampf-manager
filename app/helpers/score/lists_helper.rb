module Score::ListsHelper
  include Exports::ScoreLists

  def list_entry_options(track, entry)
    options = {}
    options[:class] = 'next-run' if track == @score_list.track_count
    options[:data] = { id: entry.id } if entry.present?
    options
  end

  def discipline_klass
    if @score_list.single_discipline?
      Person
    elsif @score_list.assessments.first.fire_relay?
      TeamRelay
    else
      Team
    end
  end

  def not_yet_present_entities
    if @score_list.assessments.first.fire_relay?
      Team.all.map { |team| TeamRelay.create_next_free_for(team, @score_list.entries.pluck(:entity_id)) }
    else
      discipline_klass.where.not(id: @score_list.entries.pluck(:entity_id))
                      .sort_by { |e| label_method_for_select_entity(e) }
    end
  end

  def label_method_for_select_entity(entity)
    decorated = entity.decorate
    if @score_list.single_discipline?
      "#{decorated.full_name} #{decorated.translated_gender}"
    else
      decorated.numbered_name_with_gender
    end
  end

  def preset_value_for(field, value)
    @score_list.send(field).blank? ? { value: value } : {}
  end
end
