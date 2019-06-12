class FireSportStatistics::PublishingsController < ApplicationController
  implement_crud_actions only: %i[new create]

  protected

  def fire_sport_statistics_publishing_params
    {}
  end

  def after_save
    flash[:success] = t('.success')
    redirect_to root_path
  end
end
