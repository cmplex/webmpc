# vim: tabstop=2 shiftwidth=2 expandtab
class SearchController < MpdController
  before_action :check_permissions, except: [:index, :search, :search_mobile]
  before_filter :perform_search, except: :index

  def index
  end

  def addAll
    @songs.each do |song|
      @@mpc.add song
    end
    render text: "Added all songs matching #{params[:needle]} to the playlist."
  end

  def addResult
    song = @songs[params[:index].to_i]
    @@mpc.add song
    render text: "Added #{song.title} by #{song.artist} to the playlist."
  end

  def search
    unless mobile?
      render json: @songs.map{ |song| [song.title, song.album, song.artist] }
    else
      render action: "index"
    end
  end

  private
    def perform_search
      @songs = @@mpc.search(:any, params[:needle])
      @query = params[:needle]
    end
end
