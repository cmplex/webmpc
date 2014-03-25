# vim: tabstop=2 shiftwidth=2 expandtab
class SettingsController < MpdController
  load_and_authorize_resource

  # GET /settings
  def index
    @settings = Setting.first
    @crossfade = @mpc.crossfade
    @repeat = @mpc.repeat?
    @random = @mpc.random?
    @consume = @mpc.consume?
  end

  # PATCH /settings/1
  def update
    @setting = Setting.find(params[:id])
    @setting.update(setting_params)
    redirect_to :back, notice: 'Settings were successfully updated.'
  end

  # POST
  def apply
    @mpc.crossfade = params[:crossfade]

    if params[:repeat]
      @mpc.repeat = true
    else
      @mpc.repeat = false
    end

    if params[:random]
      @mpc.random = true
    else
      @mpc.random = false
    end

    if params[:consume]
      @mpc.consume = true
    else
      @mpc.consume = false
    end

    redirect_to :back, notice: 'Successfully applied MPD settings.'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:next_vote_trigger, :wish_timeout)
    end
end
