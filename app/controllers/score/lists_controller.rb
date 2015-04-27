module Score
  class ListsController < ApplicationController
    implement_crud_actions 
    before_action :assign_resource_for_move, only: :move
  
    protected

    def assign_resource_for_move
      assign_existing_resource
    end
    
    def build_resource
      resource_class.new(assessment_id: params[:assessment])
    end

    def score_list_params
      params.require(:score_list).permit(:name, :assessment_id, :generator, :track_count, entries_attributes: [:id, :run, :track])
    end
  end
end