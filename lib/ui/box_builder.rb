class UI::BoxBuilder < Struct.new(:title, :options, :view, :block)
  attr_reader :body

  def initialize(*args)
    super
    @body = view.capture_haml(self, &block)
  end

  def footer(&block)
    if block.present?
      @footer = view.capture_haml(&block)
    else
      @footer
    end
  end

  def header(&block)
    if block.present?
      @header = view.capture_haml(&block)
    else
      @header
    end
  end
end