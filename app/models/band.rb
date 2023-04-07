class Band < ApplicationRecord
  include Taggable

  GENDERS = { female: 0, male: 1, indifferent: 2 }.freeze
  GENDER_KEYS = GENDERS.keys.freeze

  enum gender: GENDERS
  scope :gender, ->(gender) { where(gender: GENDERS[gender.to_sym]) }
  default_scope { order(:position) }

  has_many :assessments, class_name: 'Assessment', dependent: :restrict_with_error
  has_many :teams, dependent: :restrict_with_error
  has_many :people, dependent: :restrict_with_error
  has_and_belongs_to_many :score_list_factories, class_name: 'Score::ListFactory'

  validates :gender, :name, presence: true

  acts_as_list

  after_update do
    TagReference.all.where(taggable_type: 'Person', taggable_id: people).where.not(id: tags).delete_all
    TagReference.all.where(taggable_type: 'Team', taggable_id: teams).where.not(id: tags).delete_all
  end
end
