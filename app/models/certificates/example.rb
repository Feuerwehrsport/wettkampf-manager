# frozen_string_literal: true

class Certificates::Example
  def get(position)
    if position.key == :text
      position.text
    else
      Certificates::TextField::KEY_CONFIG[position.key].try(:[], :example)
    end
  end
end
