# vim: tabstop=2 shiftwidth=2 expandtab
class NowPlayingController < ApplicationController
  before_filter :get_current_song, only: [:index, :seek, :currentArtist, :currentAlbum, :currentTitle]

  def index
  end

  def prev
    render text: @mpc.previous
  end

  def next
    render text: @mpc.next
  end

  def toggle
    if @mpc.playing?
      render text: @mpc.pause = true
    else
      render text: @mpc.play
    end
  end

  def volDown
    vol = @mpc.volume
    vol -= 5
    if vol < 0
      vol = 0
    end
    render text: @mpc.volume = vol
  end

  def volUp
    vol = @mpc.volume
    vol += 5
    if vol > 100
      vol = 100
    end
    render text: @mpc.volume = vol
  end

  def seek
    # compute new playback position in seconds
    position = params[:factor].to_f * @song.time
    position = position.round

    # workaround for older MPD versions (< 0.17)
    command = "seek #{@song.pos} #{position}"
    @mpc.send_command command
    render text: command
  end

  def currentArtist
    render text: @song.artist
  end

  def currentAlbum
    render text: @song.album
  end

  def currentTitle
    render text: @song.title
  end

  def currentProgress
    times = @mpc.status[:time]
    progress = times[0].to_f / times[1].to_f * 100
    puts progress
    render text: progress
  end

  private
    def get_current_song
      @song = @mpc.current_song
    end
end
