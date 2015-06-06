class DisciplinesController < ApplicationController
  implement_crud_actions only: [:index, :new, :create, :show, :destroy]

  protected

  def discipline_params
    params.require(:discipline).permit(:name, :short_name, :type)
  end
end
