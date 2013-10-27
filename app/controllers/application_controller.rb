# vim: tabstop=2 shiftwidth=2 expandtab
class ApplicationController < ActionController::Base
  before_filter :prepare_for_mobile

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def mobile?
    return request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile?

  def prepare_for_mobile
    request.format = :mobile if mobile?
  end
end
