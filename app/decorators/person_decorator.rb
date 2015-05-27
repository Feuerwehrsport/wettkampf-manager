class PersonDecorator < ApplicationDecorator
  decorates_association :team

  def full_name
    "#{first_name} #{last_name}"
  end

  def team_name assessment_type=nil
    name = [team.to_s]
    name.push("E") if assessment_type == "single_competitor"
    name.push("A") if assessment_type == "out_of_competition"
    name.join(" ")
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

  def name_cols assessment_type
    [first_name, last_name, team_name(assessment_type)]
  end
end
