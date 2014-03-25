# vim: tabstop=2 shiftwidth=2 expandtab
class MpdController < ApplicationController
  include ActionController::Live

  before_filter :ensure_mpd_connection

  # global variables
  @@mpc = MPD.new('localhost', 6600, callbacks: true)
  @@artist = 'none'
  @@album = 'none'
  @@title = 'none'
  @@progress = 0
  @@playlist = []
  @@index = 0

  def ensure_mpd_connection
    unless @@mpc.connected?
      @@mpc.connect

      @@mpc.on :song do |song|
        @@artist = song.artist
        @@album = song.album
        @@title = song.title
      end

      @@mpc.on :time do |elapsed, total|
        @@progress = elapsed.to_f / total.to_f * 100
      end

      @@mpc.on :song do |song|
        @@index  = song.pos
      end

      @@mpc.on :playlist do |playlist|
        @@playlist = @@mpc.queue.map { |song| {artist: song.artist, album: song.album, title: song.title} }
      end
    end
  end

  private
    def check_permissions
      if cannot? :control_mpd, nil
        render nothing: true
      end
    end
end
