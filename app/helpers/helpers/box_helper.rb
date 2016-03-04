module Helpers::BoxHelper
  def box(title=nil, options={}, &block)
    box = UI::BoxBuilder.new(title, options, self, block)
    render('box', box: box)
  end

  def boxed_tab(options={}, &block)
    boxed_tab = UI::BoxedTabBuilder.new(options, self, block)
    render('boxed_tab', boxed_tab: boxed_tab)
  end
end