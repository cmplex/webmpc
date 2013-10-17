# vim: tabstop=2 shiftwidth=2 expandtab
module ApplicationHelper
  def current?(path)
    "current" if current_page?(path)
  end
end
