# frozen_string_literal: true

class BandsController < ApplicationController
  implement_crud_actions

  before_action :assign_tags

  def edit
    if params[:move] == 'up'
      resource_instance.move_higher
      return redirect_to action: :index
    elsif params[:move] == 'down'
      resource_instance.move_lower
      return redirect_to action: :index
    end
    super
  end

  protected

  def band_params
    params.require(:band).permit(:name, :gender,
                                 tag_references_attributes: %i[id tag_id _destroy])
  end

  def assign_tags
    @tags = Tag.all.decorate
  end
end
