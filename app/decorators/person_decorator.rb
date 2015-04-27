class PersonDecorator < ApplicationDecorator
  decorates_association :team

  def full_name
    "#{first_name} #{last_name}"
  end

  def translated_gender
    t("gender.#{gender}")
  end
end
