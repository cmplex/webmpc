# vim: tabstop=2 shiftwidth=2 expandtab
class BrowseController < MpdController
  before_action :check_permissions, only: :addSong

  def index
    @artists = @mpc.artists.sort
  end

  def listArtists
    # omit the empty string
    render json: @mpc.artists.sort[1..-1]
  end

  def listAlbums
    render json: @mpc.albums(params[:artist]).sort
  end

  def listSongs
    songs = @mpc.search("album", params[:album], {case_sensitive: true})
    render json: songs.map{ |song| [song.title, song.album, song.artist] }
  end

  def addSong
    songs = @mpc.songs_by_artist(params[:artist])
    songs.each do |song|
      if song.album == params[:album] and song.title == params[:title]
        @mpc.add(song)
        render text: "song #{params[:title]} of the album #{params[:album]} by #{params[:artist]} was added"
        return
      end
    end
    render text: "song #{params[:title]} of the album #{params[:album]} by #{params[:artist]} not found"
  end

  def browse_artists
    render :partial => "browse_artists"
    return
  end

  def browse_albums
    render :partial => "browse_albums", :locals => { :artist => params[:artist] }
    return
  end

  def browse_songs
    render :partial => "browse_songs", :locals => { :album => params[:album] }
    return
  end

end
