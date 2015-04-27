class TeamsController < ApplicationController
  implement_crud_actions

  protected

  def team_params
    params.require(:team).permit(:name, :gender, :number)
  end
end
