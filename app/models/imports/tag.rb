# frozen_string_literal: true

Imports::Tag = Struct.new(:configuration, :name, :target) do
  def import
    competition_tag.save!
  end

  def klass
    target == 'person' ? PersonTag : TeamTag
  end

  def competition_tag
    @competition_tag ||= klass.find_or_initialize_by(name: name, competition: Competition.first)
  end
end
