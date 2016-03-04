module Helpers::LinkHelper
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