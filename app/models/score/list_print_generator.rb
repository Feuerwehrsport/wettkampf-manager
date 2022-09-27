# frozen_string_literal: true

class Score::ListPrintGenerator
  extend ActiveModel::Naming
  include ActiveModel::Model

  attr_accessor :print_list

  def print_list_extended
    print_list.split(',').map do |part|
      if part.match?(/\A\d+\z/)
        possible_lists.find_by(id: part)&.decorate
      else
        part
      end
    end
  end

  def possible_lists
    @possible_lists ||= Score::List.where(hidden: false)
  end
end
