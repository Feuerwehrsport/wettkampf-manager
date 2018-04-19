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
    resource_instance.text_fields.build(key: :template, width: 100, height: 20, left: 20, top: 400, align: :center)
  end

  def certificates_template_params
    params.require(:certificates_template).permit(
      :name, :image, :font, :remove_image, :remove_font,
      text_fields_attributes: %i[left top width height size key align text id _destroy]
    )
  end
end
