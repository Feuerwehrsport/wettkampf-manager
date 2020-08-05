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
    elsif user.present? && user.api?
      can :create, API::TimeEntry
    elsif user.present?
      can(%i[edit update edit_times], Score::Run) { |r| can?(:edit_times, r.list) }
      can(%i[edit_times update], Score::List) { |r| (r.assessment_ids - user.assessment_ids).empty? }
    end
  end
end
