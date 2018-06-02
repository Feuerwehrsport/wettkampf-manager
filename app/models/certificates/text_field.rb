class Certificates::TextField < ActiveRecord::Base
  KEY_CONFIG = {
    team_name: {
      description: 'Name der Mannschaft',
      example: 'FF Warin',
    },
    person_name: {
      description: 'Name des Wettkämpfers',
      example: 'Tom Gehlert',
    },
    person_bib_number: {
      description: 'Startnummer',
      example: '1033',
    },
    time_long: {
      description: 'Zeit (Sekunden)',
      example: '23,39 Sekunden',
    },
    time_short: {
      description: 'Zeit (s)',
      example: '23,39 s',
    },
    points: {
      description: 'Punkte',
      example: 'Punkte',
    },
    rank: {
      description: 'Platz mit Punkt',
      example: '42.',
    },
    rank_with_rank: {
      description: 'Platz mit Platz',
      example: '42. Platz',
    },
    rank_without_dot: {
      description: 'Platz ohne Punkt',
      example: '42',
    },
    assessment: {
      description: 'Wertung',
      example: 'Hakenleitersteigen - U20',
    },
    assessment_with_gender: {
      description: 'Wertung mit Geschlecht',
      example: 'Hakenleitersteigen - U20 - Männer',
    },
    gender: {
      description: 'Geschlecht',
      example: 'Männer',
    },
    date: {
      description: 'Datum',
      example: '31.07.2012',
    },
    place: {
      description: 'Ort',
      example: 'Cottbus',
    },
    competition_name: {
      description: 'Name des Wettkampfes',
      example: 'Deutschland-Cup',
    },
    text: {
      description: 'Freitext',
      example: 'Hier kommt dein Text',
    },
  }.freeze

  belongs_to :template, class_name: 'Certificates::Template', inverse_of: :text_fields

  validates :template, :left, :top, :width, :height, :size, :key, :align, presence: true
  validates :key, inclusion: { in: KEY_CONFIG.keys }
  validates :align, inclusion: { in: %i[left center right] }

  def key
    super.try(:to_sym)
  end

  def align
    super.try(:to_sym)
  end
end
