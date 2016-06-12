class Presets::DCupFull < Preset
  def name
    'Deutschland-Cup (HL, HB, GS, LA, FS)'
  end

  def description_items
    [
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer',
      '4 Personen von 8 gehen in die Mannschaftswertung ein',
      'Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung',
      'Löschangriff und 4x100m Staffel für Frauen und Männer',
      'Gruppenstaffete für Frauen',
      'Gesamtwertung mit 1. Platz => 10 Punkte',
      'D-Cup Gesamtwertung',
    ]
  end

  protected

  def perform
    dcup_seed
  end
end