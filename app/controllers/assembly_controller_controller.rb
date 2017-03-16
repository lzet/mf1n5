class AssemblyControllerController < ApplicationController
  before_action :signed_in_check
  def deletetag
    current_user.tags.destroy params[:id]
    redirect_to edit_path
  end

  def deletewallet
    current_user.wallets.destroy params[:id]
    redirect_to edit_path
  end

  def edittag
    @tag = current_user.tags.find params[:id]
  end

  def editwallet
    @wallet = current_user.wallets.find params[:id]
  end

  def updatetag
    @tag = current_user.tags.find params[:id]
    if @tag && @tag.update(params.require(:tag).permit(:name, :color))
      redirect_to edit_path
    else
      render :edittag
    end
  end

  def updatewallet
    @wallet = current_user.wallets.find params[:id]
    unless params[:wallet]
      @wallet.updatevalue
      if @wallet.save
        flash[:success] = "#{t('messages.success.update')}: #{@wallet.name}"
      else
        flash[:danger] = "#{t('messages.error.update')}: #{@wallet.name}"
      end
      redirect_to edit_path
      return
    end
    if @wallet && @wallet.update(params.require(:wallet).permit(:name, :currency, :def))
      redirect_to edit_path
    else
      render :editwallet
    end
  end
end
