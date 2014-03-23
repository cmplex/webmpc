# vim: tabstop=2 shiftwidth=2 expandtab
class PlaylistController < MpdController
  before_action :check_permissions, except: [:index, :notifications, :refresh_playlist]

  def index
  end

  def clear
    @mpc.clear
    render text: "Cleared playlist."
  end

  def play
    current = @mpc.play(params[:number])
    render text: "Started playback of song number #{params[:number]} in the playlist."
  end

  def notifications
    @mpc.on :song do |song|
      R4S.push_data('playlist', {number: song.pos}, event: "currentsong")
    end
    @mpc.on :playlist do |playlist|
      songs = @mpc.queue.map { |song| {artist: song.artist, album: song.album, title: song.title} }
      R4S.push_data('playlist', songs, event: "playlist")
    end
    R4S.add_stream(response, session, "playlist").start
  end

  def refresh_playlist
    render :partial => "playlist_content"
  end

end
