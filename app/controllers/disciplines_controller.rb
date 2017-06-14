class DisciplinesController < ApplicationController
  implement_crud_actions

  protected

  def discipline_params
    attrs = [:name, :short_name, :like_fire_relay]
    attrs.push(:type) if action_name.in?(%w{new create})
    params.require(:discipline).permit(*attrs)
  end
end
