# vim: tabstop=2 shiftwidth=2 expandtab
class MpdController < ApplicationController
  include ActionController::Live

  private
    def check_permissions
      if cannot? :control_mpd, nil
        render nothing: true
      end
    end
end
