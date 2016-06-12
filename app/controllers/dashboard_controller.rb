class DashboardController < ApplicationController
  before_action do
    redirect_to(presets_path) unless Competition.one.configured?
  end
end
