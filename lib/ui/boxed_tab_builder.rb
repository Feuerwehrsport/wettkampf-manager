UI::BoxedTabBuilder = Struct.new(:options, :view, :block) do
  Tab = Struct.new(:label, :content, :class_name)
  attr_reader :tabs

  def initialize(*args)
    super
    @tabs = {}
    block.call(self)
  end

  def label(id, &block)
    @tabs[id] ||= new_tab
    @tabs[id].label = view.capture_haml(&block)
  end

  def content(id, &block)
    @tabs[id] ||= new_tab
    @tabs[id].content = view.capture_haml(&block)
  end

  def new_tab
    Tab.new(nil, nil, @tabs.keys.present? ? '' : 'active')
  end
end
