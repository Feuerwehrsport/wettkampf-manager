# frozen_string_literal: true

class Score::ListPrintGeneratorsController < ApplicationController
  def new
    @lists = Score::List.where(hidden: false)
    @list_print_generator = Score::ListPrintGenerator.new
  end

  def create
    @list_print_generator = Score::ListPrintGenerator.new(score_list_print_generator_params)

    request.format = :pdf
    send_pdf(Exports::PDF::Score::MultiList) do
      [@list_print_generator.print_list_extended]
    end
  end

  protected

  def score_list_print_generator_params
    params.require(:score_list_print_generator).permit(:print_list)
  end
end
