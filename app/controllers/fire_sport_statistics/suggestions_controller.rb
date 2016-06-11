class FireSportStatistics::SuggestionsController < ApplicationController

  def people
    suggestions = FireSportStatistics::Person.limit(10)
    suggestions = suggestions.where_name_like(params[:name]) if params[:name]
    suggestions = suggestions.order_by_gender(params[:gender]) if params[:gender]
    suggestions = suggestions.gender(params[:real_gender]) if params[:real_gender]
    suggestions = suggestions.order_by_teams(FireSportStatistics::Team.where_name_like(params[:team_name])) if params[:team_name]

    render json: suggestions.to_json(
      only: [:id, :first_name, :last_name, :gender], 
      include: [ teams: { only: [:short] } ]
    )
  end

  def teams
    suggestions = FireSportStatistics::Team.limit(10)
    suggestions = suggestions.where_name_like(params[:name]) if params[:name]

    render json: suggestions.to_json(
      only: [:id, :name, :short]
    )
  end

end
