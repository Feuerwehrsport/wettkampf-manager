module ApplicationHelper
  include TranslationHelper
  include FlashHelper

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
    @decorated_competition ||= Competition.one.decorate
  end

  def pdf_default_row_colors
    color = 264
    (1..2).map do
      color -= 12
      color.to_s(16) * 3
    end
  end

  def pdf_footer pdf
    competition = Competition.one
    name = [competition.name, l(competition.date)].join(" - ")
    pdf.page_count.times do |i|
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width, height: 30) do
        pdf.go_to_page i+1
        pdf.move_down 3

        pdf.text "#{name} - Seite #{i+1} von #{pdf.page_count}", align: :center
      end
    end
  end

  def pdf_header pdf, name, discipline=nil
    headline_y = pdf.cursor
    pdf.text name, align: :center, size: 18
    if discipline.present?
      pdf.image "#{Rails.root}/app/assets/images/disciplines/#{discipline.decorate.image}", width: 30, at: [10, headline_y]
    end
    pdf.move_down 12
  end
end
