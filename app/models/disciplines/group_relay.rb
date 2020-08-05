# frozen_string_literal: true

class Disciplines::GroupRelay < Discipline
  def group_discipline?
    true
  end

  def key
    :gs
  end
end
