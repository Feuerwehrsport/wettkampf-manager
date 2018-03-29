class API::TimeEntryDecorator < ApplicationDecorator
  decorates_association :score_list_entry

  def to_s
    second_time
  end
end
