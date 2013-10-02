# vim: tabstop=2 shiftwidth=2 expandtab
class NowPlayingController < ApplicationController
  def index
    @song = @mpc.current_song
  end
end
