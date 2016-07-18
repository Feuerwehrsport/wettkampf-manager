class Ability
  include CanCan::Ability

  def initialize(user)
    if (user.present? && user.admin?) || !User.configured?
      can :manage, :all
      cannot :destroy, user
    elsif user.present?
      can(:read, :all)
      can([:edit, :update, :edit_times], Score::Run) { |r| can?(:edit_times, r.list) }
      can([:edit_times, :update], Score::List) { |r| (r.assessment_ids - user.assessment_ids).empty? }
    else
      can :read, :all
    end
  end
end
