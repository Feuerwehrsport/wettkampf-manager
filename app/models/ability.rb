# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can :create, API::TimeEntry
    cannot :read, API::TimeEntry

    if (user.present? && user.admin?) || !User.configured?
      can :manage, :all
      cannot(:destroy, User) { |u| u.admin? || u.api? }
    elsif user.present? && !user.api?
      can(%i[edit update edit_times], Score::Run) do |r|
        list = r.list.is_a?(ApplicationDecorator) ? r.list.object : r.list
        can?(:edit_times, list)
      end
      can(%i[edit_times update], Score::List) { |r| (r.assessment_ids - user.assessment_ids).empty? }

      case user.edit_type
      when 'both'
        can(%i[edit_times edit_result_types], Score::ListEntry)
      when 'only_times'
        can(:edit_times, Score::ListEntry)
      when 'only_result_types'
        can(:edit_result_types, Score::ListEntry)
      end
    end
  end
end
