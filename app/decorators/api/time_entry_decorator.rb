# frozen_string_literal: true

class API::TimeEntryDecorator < ApplicationDecorator
  decorates_association :score_list_entry
end
