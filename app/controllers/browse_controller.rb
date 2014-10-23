# vim: tabstop=2 shiftwidth=2 expandtab
class BrowseController < MpdController
  before_action :check_permissions, only: [:addSong, :addAlbum, :addArtist, :updateDatabase]

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
    artist = params[:artist].strip
    album = params[:album].strip
    title = params[:title].strip

    songs = @@mpc.songs_by_artist(artist)
    songs.each do |song|
      if song.album == album and song.title == title
        @@mpc.add(song)
        render text: "song #{title} of the album #{album} by #{artist} was added"
        return
      end
    end
    render text: "song #{title} of the album #{album} by #{artist} not found"
  end

  def browse_artists
    artists = @@mpc.artists.sort
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

  def addAlbum
      album_name = params[:album].strip
      @songs = @@mpc.search(:album, album_name)
      @songs.each do |song|
        @@mpc.add song
      end
      render text: "Added album #{params[:album]} to the playlist"
  end

  def addArtist
      @songs = @@mpc.search(:artist, params[:artist])
      @songs.each do |song|
        @@mpc.add song
      end
      render text: "Added artist #{params[:artist]} to the playlist"
  end

  def updateDatabase
    if @@mpc.update
      render text: "Database update started"
    else
      render text: "Database update could not be started"
    end
  end
end
