class AdministrateController < ApplicationController
  include ApplicationHelper
  before_action :admin_check

  def edit
    @resource = User.find_by(id: params[:id])
    unless @resource
      redirect_to admin_path, genflash(:alert, t('messages.error.not_found'))
    else
      @btntitle = t('ui.button.title.update')
    end
  end

  def new
    @resource = User.new
    @btntitle = t('ui.button.title.create')
  end

  def delete
    @resource = User.find_by(id: params[:id])
    if @resource
      unless @resource.admin?
        @resource.destroy
        flash_msg = {:success => "#{t('messages.success.delete')} #{@resource.email}"}
      end
    else
      flash_msg = {:alert => t('messages.error.not_found')}
    end
    redirect_to admin_path, :flash => flash_msg
  end

  def create
    @resource = User.new(user_permit)
    unless @resource.save
      @btntitle = t('ui.button.title.create')
      render 'new'
    else
      redirect_to admin_path, genflash(:success, t('messages.success.create'))
    end
  end

  def update
    @resource = User.find_by(id: params[:id])
    if !@resource
      redirect_to admin_path, genflash(:alert, t('messages.error.not_found'))
    elsif @resource.update(user_permit)
      redirect_to admin_path, genflash(:success, t('messages.success.update'))
    else
      @btntitle = t('ui.button.title.update')
      render 'edit'
    end
  end

  private
    def user_permit
      params.require(:newuser).permit(:email, :password, :password_confirmation)
    end

    def genflash sym, txt
      if @resource
        {:flash => {sym => "#{txt} #{@resource.email}"}}
      else
        {:flash => {sym => "#{txt}"}}
      end
    end

end
