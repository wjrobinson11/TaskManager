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
    permissions_method = user.class.to_s.underscore
    send permissions_method
  end

  def super_admin
    # Add array argument for defining specific attributes, omitting array will authorize all attributes
    can :manage, User, [:type, :email, :password, :password_confirmation, :company_id]
    can :manage, Company
    can :manage, Task
  end

  def task_admin
    can :manage, Task, [:name, :description, :price], company_id: user.company_id
  end
end
