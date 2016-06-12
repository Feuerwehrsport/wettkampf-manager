class Presets::DCupSmall < Preset
  def name
    'Deutschland-Cup (HL, HB, GS, LA)'
  end

  def description_items
    [
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer',
      '4 Personen von 8 gehen in die Mannschaftswertung ein',
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung',
      'Löschangriff für Frauen und Männer',
      'Gruppenstaffete für Frauen',
      'Gesamtwertung mit 1. Platz => 10 Punkte',
      'D-Cup Gesamtwertung',
    ]
  end

  protected

  def perform
    dcup_seed(false)
  end
end