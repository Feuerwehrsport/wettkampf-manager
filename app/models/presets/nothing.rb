class Presets::Nothing < Preset
  def name
    'Leere Vorlage'
  end

  def description_items
    [
      'Es wird nichts angelegt.',
    ]
  end

  protected

  def perform
  end
end