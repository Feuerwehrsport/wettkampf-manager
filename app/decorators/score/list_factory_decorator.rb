class Score::ListFactoryDecorator < ApplicationDecorator
  def possible_type_with_names
    possible_types.map do |type|
      [type.model_name.human, type.to_s]
    end
  end
end
