# vim: tabstop=2 shiftwidth=2 expandtab
class BrowseController < MpdController
  before_action :check_permissions, only: [:addSong, :updateDatabase]

  def index
    @artists = @@mpc.artists.sort
  end

  def listArtists
    # omit the empty string
    render json: @@mpc.artists.sort[1..-1]
  end

  def listAlbums
    render json: @@mpc.albums(params[:artist]).sort
  end

  def listSongs
    songs = @@mpc.search("album", params[:album], {case_sensitive: true})
    render json: songs.map{ |song| [song.title, song.album, song.artist] }
  end

  def addSong
    songs = @@mpc.songs_by_artist(params[:artist])
    songs.each do |song|
      if song.album == params[:album] and song.title == params[:title]
        @@mpc.add(song)
        render text: "song #{params[:title]} of the album #{params[:album]} by #{params[:artist]} was added"
        return
      end
    end
    render text: "song #{params[:title]} of the album #{params[:album]} by #{params[:artist]} not found"
  end

  def browse_artists
    artists = @@mpc.artists.sort[1..-1]
    render partial: "browse_artists", locals: { artists: artists }
    return
  end

  def browse_albums
    albums = @@mpc.albums(params[:artist]).sort
    render partial: "browse_albums", locals: { albums: albums }
    return
  end

  def browse_songs
    songs = @@mpc.search("album", params[:album])
    render partial: "browse_songs", locals: { songs: songs }
    return
  end

  def updateDatabase
    if @@mpc.update
      render text: "Database update started"
    else
      render text: "Database update could not be started"
    end
  end
end
