# frozen_string_literal: true

class DisciplinesController < ApplicationController
  implement_crud_actions

  protected

  def index_collection
    super.decorate.sort_by(&:to_s)
  end

  def discipline_params
    attrs = %i[name short_name like_fire_relay]
    attrs.push(:type) if action_name.in?(%w[new create])
    params.require(:discipline).permit(*attrs)
  end
end
