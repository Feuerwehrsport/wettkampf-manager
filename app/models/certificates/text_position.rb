class Certificates::TextPosition < CacheDependendRecord
  KEY_CONFIG = {
    team_name: {
      description: "Name der Mannschaft",
      example: "FF Warin",
    },
    person_name: {
      description: "Name des Wettkämpfers",
      example: "Tom Gehlert",
    },
    person_bib_number: {
      description: "Startnummer",
      example: "1033",
    },
    time_long: {
      description: "Zeit (Sekunden)",
      example: "23,39 Sekunden",
    },
    time_short: {
      description: "Zeit (s)",
      example: "23,39 s",
    },
    points: {
      description: "Punkte",
      example: "Punkte",
    },
    rank: {
      description: "Platz",
      example: "42.",
    },
    assessment: {
      description: "Wertung",
      example: "Hakenleitersteigen - U20",
    },
    assessment_with_gender: {
      description: "Wertung mit Geschlecht",
      example: "Hakenleitersteigen - U20 - männlich",
    },
    gender: {
      description: "Geschlecht",
      example: "männlich",
    },
    date: {
      description: "Datum",
      example: "31.07.2012",
    },
    place: {
      description: "Ort",
      example: "Cottbus",
    },
    competition_name: {
      description: "Name des Wettkampfes",
      example: "Deutschland-Cup",
    },
  }

  belongs_to :template
  validates :template, :key, :top, :left, :align, :size, presence: true

  def key
    super.try(:to_sym)
  end

  def description
    KEY_CONFIG[key][:description]
  end

  def example
    KEY_CONFIG[key][:example]
  end
end
