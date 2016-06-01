class Score::ResultEntry
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  include Score::ResultEntrySupport
  include Draper::Decoratable

  attr_accessor :time, :result_type
end