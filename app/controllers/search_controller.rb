# vim: tabstop=2 shiftwidth=2 expandtab
class SearchController < ApplicationController
  before_filter :perform_search, except: :index

  def index
  end

  def addAll
    @songs.each do |song|
      @mpc.add song
    end
    render text: "Added all songs matching #{params[:needle]} to the playlist."
  end

  def addResult
    song = @songs[params[:index].to_i]
    @mpc.add song
    render text: "Added #{song.title} by #{song.artist} to the playlist."
  end

  def search
    render json: @songs.map{ |song| [song.title, song.album, song.artist] }
  end

  private
    def perform_search
      @songs = @mpc.search(:any, params[:needle])
    end
end
