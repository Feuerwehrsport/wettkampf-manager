class Score::Run
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include Draper::Decoratable

  attr_accessor :list, :run_number
  attr_reader :list_entries


  def initialize *args
    super *args
    @list_entries = @list.entries.where(run: run_number)
    raise ActiveRecord::RecordNotFound.new if @list_entries.count == 0
  end

  def persisted?
    true
  end

  def list_entries_attributes= attributes
    attributes.each do |key, entry_attributes|
      entry = list_entries.select { |e| e.track == entry_attributes[:track].to_i }.first
      entry.update_attributes(entry_attributes)
    end
  end

  def update_attributes attributes
    self.list_entries_attributes = attributes[:list_entries_attributes]
  end
end