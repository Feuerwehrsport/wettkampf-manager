class Imports::Tag < CacheDependendRecord
  belongs_to :configuration, class_name: 'Imports::Configuration', inverse_of: :tags
  validates :name, :configuration, :target, presence: true

  def target
    super.try(:to_sym)
  end

  def import
    return unless use

    klass.find_or_create_by!(name: name, competition: Competition.first)
  end

  def klass
    target == :person ? PersonTag : TeamTag
  end

  def competition_tag
    klass.find_by(name: name, competition: Competition.first)
  end
end
