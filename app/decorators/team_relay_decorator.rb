class TeamRelayDecorator < ApplicationDecorator
  decorates_association :team

  def to_s(full=false)
    full ? numbered_name_with_gender : "#{team} #{name}"
  end

  def numbered_name_with_gender
    "#{team.numbered_name_with_gender} #{name}"    
  end
  
  def self.human_name_cols
    ["Mannschaft"]
  end

  def name_cols assessment_type
    [to_s]
  end
end
