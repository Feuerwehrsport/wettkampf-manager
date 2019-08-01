class Certificates::TemplatesController < ApplicationController
  implement_crud_actions

  def show
    super
    if request.format.json?
      send_data resource_instance.to_json,
                type: 'text/json',
                disposition: "attachment; filename=\"urkundenvorlage-#{resource_instance.name.parameterize}.json\""
    end
    page_title('Urkundenvorlage')
    send_pdf(Exports::PDF::Certificates::Export) do
      [@certificates_template, "Urkundenvorlage: #{resource_instance.name}", [Certificates::Example.new], true]
    end
  end

  def edit
    super
    @text_position_form = params[:form_type] == 'text_positions'
  end

  def duplicate
    assign_existing_resource
    new_instance = resource_instance.dup
    resource_instance.text_fields.each do |field|
      new_instance.text_fields << field.dup
    end
    new_instance.font = resource_instance.font if resource_instance.font.present?
    new_instance.font2 = resource_instance.font2 if resource_instance.font2.present?
    new_instance.image = resource_instance.image if resource_instance.image.present?
    new_instance.name += ' (Duplikat)'
    new_instance.save!
    redirect_to action: :show, id: new_instance
  end

  protected

  def index_collection
    super.reorder(:name)
  end

  def assign_resource_for_edit
    super
    resource_instance.text_fields.build(key: :template, width: 100, height: 20, left: 20, top: 400, align: :center)
  end

  def certificates_template_params
    params.require(:certificates_template).permit(
      :name, :image, :font, :font2, :remove_image, :remove_font, :remove_font2,
      text_fields_attributes: %i[left top width height size key font align text id color _destroy]
    )
  end
end
