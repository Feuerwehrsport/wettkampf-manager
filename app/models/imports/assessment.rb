# frozen_string_literal: true

Imports::Assessment = Struct.new(:configuration, :import_band, :data) do
  def foreign_key
    data[:id]
  end

  def name
    data[:name]
  end

  def discipline_key
    data[:discipline]
  end

  def discipline
    @discipline ||= Discipline.instance_for_key(discipline_key)
  end

  def assessment
    @assessment || import_band.band.assessments.find_or_initialize_by(discipline: discipline, name: name)
  end

  def import
    assessment.save!
  end
end
