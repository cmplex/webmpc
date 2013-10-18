# vim: tabstop=2 shiftwidth=2 expandtab
module ApplicationHelper
  def current?(path)
    return "current" if current_page?(path)
  end

  def nav_link(link_text, path)
    link_to link_text, path, class: current?(path), onFocus: "blur();"
  end

  def menu_link(link_text, path, method=:post)
    link_to link_text, path, method: method, remote: true, onFocus: "blur();"
  end
end
