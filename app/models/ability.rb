# frozen_string_literal: true

class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    set_permissions
  end

  protected

  def set_permissions
    permissions_method = user.present? ? user.class.to_s.underscore : 'guest'
    send permissions_method
  end

  def super_admin
    can :manage, :all
  end

  def task_admin
    # Add array argument for defining specific attributes, omitting array will authorize all attributes
    can :manage, Task, [:name, :description, :price], company_id: user.company_id
  end

  def guest
    # Add guest permissions if needed
  end
end
