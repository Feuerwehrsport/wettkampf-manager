class SecondTimeInput < SimpleForm::Inputs::NumericInput
  def input(wrapper_options = nil)
    input_html_options[:step] = '0.01'
    super wrapper_options
  end
end
