# vim: tabstop=2 shiftwidth=2 expandtab
class NowPlayingController < MpdController
  before_action :check_permissions, except: [:index, :notifications, :albumarturl]

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
    @song = @mpc.current_song
    position = params[:factor].to_f * @song.time
    position = position.round

    # workaround for older MPD versions (< 0.17)
    command = "seek #{@song.pos} #{position}"
    @mpc.send_command command
    render text: command
  end

  def notifications
    @mpc.on :song do |song|
      R4S.push_data('now_playing', {artist: song.artist, album: song.album, title: song.title}, event: "song")
    end
    @mpc.on :time do |elapsed, total|
      progress = elapsed.to_f / total.to_f * 100
      R4S.push_data('now_playing', {progress: progress}, event: "progress")
    end
    R4S.add_stream(response, session, "now_playing").start
  end

  def albumarturl
    artistname = params[:artistname]
    albumname = params[:albumname]

    url = 'assets/default.png'
    filename = (Digest::SHA1.hexdigest artistname+albumname)+".png"


    begin
      File.open("app/assets/images/"+filename, 'r')
      url = "assets/"+filename
    rescue StandardError => e
      album = Rockstar::Album.new(artistname, albumname, :include_info => true)
    end

    
    if(not album.nil?)
      begin
        url = album.images["extralarge"]
        if not(system("wget "+url+" -O "+"app/assets/images/"+filename))
          raise IOError
        end
      rescue StandardError => e
        url = 'assets/default.png'
      end
    end

    render text: url
    return
  end
end
