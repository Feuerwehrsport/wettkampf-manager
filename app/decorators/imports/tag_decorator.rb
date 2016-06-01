class Imports::TagDecorator < ApplicationDecorator
  def target
    object.target == :person ? 'Wettkämpfer' : 'Mannschaft'
  end
end
