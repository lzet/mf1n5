class ItemsController < ApplicationController
  before_action :signed_in_check
  def create
    @item = Item.new
    @item.extinit current_user, itemext_permit
    if @item.save 
      redirect_to root_path
    else
      render :new
    end
  end

  def new
    render :nowallet unless current_user.defaultwallet
    @item = Item.new(user: current_user, wallet: current_user.defaultwallet)
  end

  def edit
    @item = findbyid params[:id]
    unless @item
      redirect_to root_path
    else
      render :edit
    end
  end

  def index
    redirect_to root_path
  end

  def show
    redirect_to root_path
  end

  def destroy
    @item = findbyid params[:id]
    @item.destroy if @item
    redirect_to root_path
  end

  def update
    @item = findbyid params[:id]
    unless @item
      redirect_to root_path
      return
    end
    if @item.wallet_id != params[:wallet_id]
      @item.destroy
      @item = Item.new
    end
    @item.extinit current_user, itemext_permit
    if @item.save
      redirect_to root_path
    else
      render :edit
    end

  end

  def ajax
    @item = findbyid params[:id]
    unless @item
      if params[:nofull]
        render text: ''
      else
        redirect_to root_path
      end
      return
    end
    if params[:nofull]
      render :iteminfo, layout: false
    else
      render :iteminfo
    end
  end

  private
    def itemext_permit
      params.require(:item).permit(:name, :wallet_id, :valueabs, :checkbox, :date, :time, :tags_s)
    end

    def findbyid(id)
      current_user.items.find params[:id]
    end

end
