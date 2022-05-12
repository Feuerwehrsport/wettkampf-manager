# frozen_string_literal: true

class Preset
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :id
  alias to_param id

  def self.preset_classes
    [
      Presets::Nothing,
      Presets::FireAttack,
      Presets::DCupFull,
      Presets::DCupSmall,
      Presets::HallCup,
      Presets::MvCupSingle,
      Presets::BrandenburgJugend,
      Presets::Sonnenwalde,
      Presets::SonnenwaldeKreisausscheid,
      Presets::EuregioCup,
      Presets::LandesmeisterschaftBrandenburg2017,
      Presets::Heedebockpokal,
      Presets::Dm2022,
    ]
  end

  def self.all
    preset_classes.each_with_index.map { |klass, id| klass.new(id: (id + 1)) }
  end

  def self.find(id)
    all.find { |preset| preset.id == id.to_i } || raise(ActiveRecord::RecordNotFound)
  end

  def save
    ActiveRecord::Base.transaction do
      perform
      Competition.one.update!(configured: true)
    end
  end

  protected

  def year
    @year ||= Date.current.year
  end

  def series(result, round_name, name_part: nil, not_name_part: nil)
    assessments = result.possible_series_assessments.year(year).round_name(round_name)
    assessment = if name_part.nil? && not_name_part.nil?
                   assessments.first
                 elsif name_part
                   assessments.find { |a| a.name.include?(name_part) }
                 else
                   assessments.find { |a| !a.name.include?(not_name_part) }
                 end
    [assessment].compact
  end

  def perform; end
end
