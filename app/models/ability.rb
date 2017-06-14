class Ability
  include CanCan::Ability

  def initialize(user)
    if (user.present? && user.admin?) || !User.configured?
      can :manage, :all
      cannot(:destroy, User) { |u| u.admin? || u.api? }
    elsif user.api?
      can :create, API::TimeEntry
    elsif user.present?
      can([:edit, :update, :edit_times], Score::Run) { |r| can?(:edit_times, r.list) }
      can([:edit_times, :update], Score::List) { |r| (r.assessment_ids - user.assessment_ids).empty? }
    end
    can :read, :all
    can :create, API::TimeEntry
  end
end
