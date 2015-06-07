class TeamRelay < ActiveRecord::Base
  belongs_to :team
  has_many :list_entries, class_name: "Score::ListEntry", as: :entity, dependent: :destroy
  
  validates :team, :name, presence: true

  def self.name_for_number number
    (64+number).chr
  end
end
