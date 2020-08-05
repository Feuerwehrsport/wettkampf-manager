# frozen_string_literal: true

class CompetitionDecorator < ApplicationDecorator
  def to_s
    name
  end
end
