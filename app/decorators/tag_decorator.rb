# frozen_string_literal: true

class TagDecorator < ApplicationDecorator
  def to_s
    name
  end
end
