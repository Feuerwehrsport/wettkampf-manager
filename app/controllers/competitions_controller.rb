class CompetitionsController < ApplicationController
  implement_crud_actions only: [:show, :edit, :update]

  protected

  def competition_params
    params.require(:competition).permit(:name, :date)
  end
end
