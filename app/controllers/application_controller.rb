# vim: tabstop=2 shiftwidth=2 expandtab
class ApplicationController < ActionController::Base
  after_filter :close_mpd_connection
  before_filter :open_mpd_connection, :prepare_for_mobile

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def open_mpd_connection
    @mpc = MPD.new('localhost', 6600, callbacks: true)
    @mpc.connect
  end

  def close_mpd_connection
    @mpc.disconnect
  end

  def mobile?
    return request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile?

  def prepare_for_mobile
    request.format = :mobile if mobile?
  end
end
