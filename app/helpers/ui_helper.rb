module UIHelper
  def box(title, options = {}, &block)
    @@box_index ||= 0
    @@box_index += 1
    options[:type] ||= :primary
    keep_context do
      render(
        'box',
        title: translate_or_use(title),
        block: block,
        index: @@box_index,
        options: options
      )
    end
  end

  def boxed_tab
    builder = UI::BoxedTabBuilder.new
    yield(builder)
    keep_context do
      render(
        'boxed_tab',
        tabs: builder.tabs
      )
    end
  end

  def box_classes(options)
    classes = []
    classes << "box-#{options[:type]}"
    classes << "box-solid" if options[:solid]
    classes << "bg-#{options[:bg]}" if options[:bg]
    classes << "panel" if options[:collapsable]
    classes.join(' ')
  end

  def boxed_form_for(title, record, form_options = {}, &block)
    box_options = form_options.extract!(:box)[:box] || {}
    form_options[:builder] ||= UI::BoxedSimpleFormBuilder
    form_options[:html] ||= {}
    form_options[:html][:autocomplete] ||= 'off'
    box_options[:type] ||= :primary
    keep_context do
      render(
        'boxed_form',
        title: translate_or_use(title),
        record: record,
        form_options: form_options,
        form_block: block,
        options: box_options
      )
    end
  end

  def link_btn name, path, options = {}
    options[:class] ||= ""
    options[:class] += " btn btn-sm btn-default"
    link_to name, path, options
  end

  def btn_link_to(label, url, options = {})
    options[:class] ||= ""
    options[:class] += " btn btn-sm btn-default"
    link_to(label, url, options)
  end

  def cancel_link(url=nil, options={ class: "btn btn-link" })
    url = { action: action_name.to_sym.in?([:new, :create, :destroy]) ? :index : :show } if url.nil?
    link_to("Abbrechen", url, options)
  end

  def block_link_to(label, url, options={})
    options[:class] ||= ""
    options[:class] += " btn-block"
    btn_link_to(label, url, options)
  end
end