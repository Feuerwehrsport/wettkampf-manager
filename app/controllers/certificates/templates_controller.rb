class Certificates::TemplatesController < ApplicationController
  implement_crud_actions

  def show
    super
    page_title('Urkundenvorlage', margin: [0, 0, 0, 0])
  end

  def edit
    super
    @text_position_form = params[:form_type] == 'text_positions'
  end

  protected

  def assign_resource_for_edit
    super
    Certificates::TextPosition::KEY_CONFIG.keys.each do |key|
      resource_instance.text_positions.find_or_initialize_by(key: key)
    end
  end

  def certificates_template_params
    params.require(:certificates_template).permit(
      :name, :image, :font, :remove_image, :remove_font,
      text_positions_attributes: %i[key top left align size id _destroy]
    )
  end
end
