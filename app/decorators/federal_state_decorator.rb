# frozen_string_literal: true

class FederalStateDecorator < ApplicationDecorator
  def to_s
    name
  end
end
