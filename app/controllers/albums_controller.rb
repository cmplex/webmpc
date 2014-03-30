class AlbumsController < MpdController
  load_and_authorize_resource
  before_action :set_album, only: [:show, :edit, :update, :destroy]

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render action: 'show', status: :created, location: @album }
      else
        format.html { render action: 'new' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  def retrieve_covers
    albums = @@mpc.search(:any, " ").map{ |album| [album.album, album.artist]}.uniq

    albums.each do |mpc_album|
      album = Album.find_or_create_by title: mpc_album[0], artist: mpc_album[1]
      begin
        if not album.cover.exists?
          albuminfo = Rockstar::Album.new(mpc_album[1], mpc_album[0], :include_info => true)
          remote_url = albuminfo.images["extralarge"]

          # if album cover available remotely
          if !remote_url.nil? || remote_url.length == 0
            album.cover = remote_url
            album.save
          end
        end

      rescue SocketError
        p "No internet connection!"

      end
    end

    render text: "Done."
  end

  def reset
    @albums.each do |album|
      album.destroy
    end

    render text: "Done."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:cover)
    end
end
