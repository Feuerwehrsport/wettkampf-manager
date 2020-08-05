# frozen_string_literal: true

module Helpers::BoxHelper
  def box(title = nil, options = {}, &block)
    box = UI::BoxBuilder.new(title, options, self, block)
    render('box', box: box)
  end
end
