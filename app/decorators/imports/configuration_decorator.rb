class Imports::ConfigurationDecorator < ApplicationDecorator
  decorates_association :tags
  decorates_association :assessments
end
