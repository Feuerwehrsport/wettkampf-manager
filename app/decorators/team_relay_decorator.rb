class TeamRelayDecorator < ApplicationDecorator
  decorates_association :team

  def to_s
    "#{team} #{name}"
  end
  
  def self.human_name_cols
    ["Mannschaft"]
  end

  def name_cols assessment_type
    [to_s]
  end
end
