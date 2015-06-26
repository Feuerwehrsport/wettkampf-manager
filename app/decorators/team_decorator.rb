class TeamDecorator < ApplicationDecorator
  decorates_association :people
  decorates_association :team_relays

  def translated_gender
    t("gender.#{gender}")
  end

  def numbered_name
    if Team.gender(gender).where(name: name).where.not(id: id).count > 0
      "#{name} #{number}"
    else
      name
    end
  end

  def numbered_name_with_gender
    "#{numbered_name} #{translated_gender}"
  end

  def short_name length = 15
    numbered_name.truncate(length)
  end

  def to_s(full=false)
    full ? numbered_name_with_gender : numbered_name
  end

  def self.human_name_cols
    ["Mannschaft"]
  end

  def name_cols assessment_type
    [to_s]
  end
end
