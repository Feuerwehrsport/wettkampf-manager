class TeamDecorator < ApplicationDecorator
  decorates_association :people

  def translated_gender
    t("gender.#{gender}")
  end

  def numbered_name
    if Team.where(name: name, gender: gender).where.not(id: id).count > 0
      "#{name} #{number}"
    else
      name
    end
  end

  def short_name length = 15
    numbered_name.truncate(length)
  end
end
