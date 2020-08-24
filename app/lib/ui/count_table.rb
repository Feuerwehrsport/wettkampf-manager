# frozen_string_literal: true

UI::CountTable = Struct.new(:view, :rows, :options, :columns) do
  def initialize(*args)
    super
    self.options ||= {}
    self.columns = []
    yield self
  end

  def col(column_head, column_key = nil, options = {}, &block)
    if column_key.is_a? Hash
      options = column_key
      column_key = nil
    end
    columns.push UI::Column.new(self, column_head, column_key, options, block)
  end
end

UI::Column = Struct.new(:count_table, :name, :key, :options, :block) do
  def content(row)
    if key.present?
      row.try(key)
    else
      block.call(row)
    end
  end

  def th_options
    options[:th_options] || {}
  end
end
