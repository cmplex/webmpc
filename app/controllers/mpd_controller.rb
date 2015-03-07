# vim: tabstop=2 shiftwidth=2 expandtab
class MpdController < ApplicationController
  include ActionController::Live

  before_filter :ensure_mpd_connection

  # global variables
  @@mpc = MPD.new('localhost', 6600, callbacks: true)
  @@artist = 'none'
  @@album = 'none'
  @@title = 'none'
  @@elapsed = 0
  @@duration = 0
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
        @@elapsed = elapsed.to_f
        @@duration = total.to_f
      end

      @@mpc.on :song do |song|
        @@index  = song.pos
      end

      @@mpc.on :playlistlength do
        @@index = @@mpc.status[:song]
      end

      @@mpc.on :playlist do
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
