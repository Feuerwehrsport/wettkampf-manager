module ApplicationHelper

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

  def partial_exists?(partial_path)
    lookup_context.template_exists?(partial_path, controller._prefixes, true)
  end

  def page_title
    controller_path.classify.constantize.model_name.human
  end

  def link_btn name, path, options = {}
    options[:class] ||= ""
    options[:class] += " btn btn-sm btn-default"
    link_to name, path, options
  end

  def short_edit_link path, options = {}
    options[:title] ||= "Bearbeiten"
    icon_link_btn('ion ion-edit', path, options)
  end

  def short_destroy_link path, options = {}
    options[:title] ||= "Löschen"
    icon_link_btn('ion ion-trash-a', path, options)
  end

  def short_show_link path, options = {}
    options[:title] ||= "Ansehen"
    icon_link_btn('ion ion-eye', path, options)
  end

  def icon_link_btn icon_classes, path, options = {}
    link_btn(content_tag(:i, '', class: icon_classes), path, options)
  end

  def discipline_image discipline, options = {}
    options[:size] ||= "20x20"
    image_tag "disciplines/#{discipline.image}", options
  end

  def decorated_competition
    @decorated_competition = Competition.first.decorate
  end
end
