module ApplicationController::CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user,  :current_userid, :current_username
    helper_method :current_group, :current_groupid, :current_group_description
  end

  def clear_current_user
    self.current_user = nil
  end
  protected :clear_current_user

  def current_user=(db_user)
    if db_user
      User.current_userid = db_user.userid
      session[:userid]    = db_user.userid
      session[:username]  = db_user.name
    else
      User.current_userid = nil
      session[:userid]    = nil
      session[:username]  = nil
    end
  end
  protected :current_user=

  def current_group=(db_group)
    session[:group] = db_group.try(:id)
    session[:group_description] = db_group.try(:description)

    role = db_group.try(:miq_user_role)

    session[:role] = role.try(:id)
    # Build pre-sprint 69 role name if this is an EvmRole read_only role
    session[:userrole] = role.try(:read_only?) ? role.name.split("-").last : ""
  end
  protected :current_group=

  def current_user
    @current_user ||= User.find_by_userid(session[:userid])
  end
  protected :current_user

  # current_user.userid
  def current_userid
    session[:userid]
  end
  protected :current_userid

  # current_user.username
  def current_username
    session[:username]
  end
  protected :current_username

  def current_group
    @current_group ||= MiqGroup.find_by_id(session[:group])
  end

  # current_group.id
  def current_groupid
    session[:group]
  end
  protected :current_groupid

  def current_group_description
    session[:group_description]
  end
  protected :current_group_description

  def current_role
    session[:role]
  end
  protected :current_role

  def current_userrole
    session[:userrole]
  end
  protected :current_userrole
end
