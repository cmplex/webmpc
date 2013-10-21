# vim: tabstop=2 shiftwidth=2 expandtab
class SettingsController < ApplicationController
  load_and_authorize_resource

  # GET /settings
  def index
    @settings = Setting.first
  end

  # PATCH/PUT /settings/1
  def update
    @setting = Setting.find(params[:id])
    @setting.update(setting_params)
    redirect_to :back, notice: 'Settings were successfully updated.'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:next_vote_trigger, :wish_timeout)
    end
end
