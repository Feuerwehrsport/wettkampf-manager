module ApplicationHelper
  include UIHelper
  include PDFHelper
  include TranslationHelper
  include FlashHelper

  def partial_exists?(partial_path)
    lookup_context.template_exists?(partial_path, controller._prefixes, true)
  end

  def page_title
    controller_path.classify.constantize.model_name.human
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
end
