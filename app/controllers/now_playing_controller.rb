# vim: tabstop=2 shiftwidth=2 expandtab
class NowPlayingController < MpdController
  before_action :check_permissions, except: [:index, :songInfo, :albumarturl]

  def index
  end

  def prev
    render text: @@mpc.previous
  end

  def next
    render text: @@mpc.next
  end

  def toggle
    if @@mpc.playing?
      render text: @@mpc.pause = true
    else
      render text: @@mpc.play
    end
  end

  def resume
    render text: @@mpc.play
  end

  def pause
    render text: @@mpc.pause = true
  end

  def volDown
    vol = @@mpc.volume
    vol -= 5
    if vol < 0
      vol = 0
    end
    render text: @@mpc.volume = vol
  end

  def volUp
    vol = @@mpc.volume
    vol += 5
    if vol > 100
      vol = 100
    end
    render text: @@mpc.volume = vol
  end

  def setVol
    render text: @@mpc.volume = params[:volume]
  end

  def seek
    # compute new playback position in seconds
    @song = @@mpc.current_song
    position = params[:factor].to_f * @song.time
    position = position.round

    # workaround for older MPD versions (< 0.17)
    command = "seek #{@song.pos} #{position}"
    @@mpc.send_command command
    render text: command
  end

  def songInfo
    render json: {artist: @@artist, album: @@album, title: @@title, progress: @@progress}
  end

  def albumarturl
    artistname = params[:artistname]
    albumname = params[:albumname]

    album = Album.find_or_create_by title: albumname, artist: artistname
    begin
      if not album.cover.exists?
        albuminfo = Rockstar::Album.new(artistname, albumname, :include_info => true)
        remote_url = albuminfo.images["extralarge"]

        # if album cover available remotely
        if !remote_url.nil? || remote_url.length > 0
          album.cover = remote_url
          album.save
        end
      end

    rescue SocketError
      p "No internet connection!"

    end


    if not album.cover.exists?
      render text: ActionController::Base.helpers.asset_path(album.cover.url)
    else
      render text: album.cover.url
    end

    return
  end

end
