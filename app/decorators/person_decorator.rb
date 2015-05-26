class PersonDecorator < ApplicationDecorator
  decorates_association :team

  def full_name
    "#{first_name} #{last_name}"
  end

  def translated_gender
    t("gender.#{gender}")
  end

  def to_s
    full_name
  end

  def self.human_name_cols
    ["Vorname", "Nachname", "Mannschaft"]
  end

  def name_cols
    [first_name, last_name, team.to_s]
  end
end
