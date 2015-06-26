module UI
  class BoxedTabBuilder
    attr_reader :tabs

    def initialize
      @tabs = {}
      @first = true
    end

    def name key, &block
      @tabs[key] ||= new_entry
      @tabs[key].name = block
    end

    def content key, &block
      @tabs[key] ||= new_entry
      @tabs[key].content = block
    end

    def new_entry
      if @first
        active_class = "active"
        @first = false
      else
        active_class = ""
      end
      OpenStruct.new(content: nil, name: nil, class_name: active_class)
    end
  end
end