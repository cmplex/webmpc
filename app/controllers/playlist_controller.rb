# vim: tabstop=2 shiftwidth=2 expandtab
class PlaylistController < MpdController
  before_action :check_permissions, except: [:index, :playlist, :refresh_playlist]

  def index
  end

  def clear
    @@mpc.clear
    render text: "Cleared playlist."
  end

  def play
    current = @@mpc.play(params[:number])
    render text: "Started playback of song number #{params[:number]} in the playlist."
  end

  def playlist
    render json: {songs: @@playlist, index: @@index}
  end

  def refresh_playlist
    songs = @@mpc.queue.map { |song| {artist: song.artist, album: song.album, title: song.title} }
    render :partial => "playlist_content", :locals => { :songs => songs }
    return
  end

end
