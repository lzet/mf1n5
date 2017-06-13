class MainPagesController < ApplicationController
  before_action :signed_in_check
  before_action :admin_check, only: [:admin]
  before_action :initval, only: [:edit, :update]
  LIMITPAGE = 30

  def home
    if params[:page]
      page = params[:page].to_i
    else
      page = 0
    end
    @items, @pagecnt, @pagecur, @total = current_user.items.itemsandpagecount(
                                    current_user, LIMITPAGE, page,
                                    MainPagesHelper::getcurrentfilter(params))
  end

  def graph
    @grapharray = rendercharts(
                    current_user.items.getpagewithfilters(
                      current_user, MainPagesHelper::getcurrentfilter(params))[0])
    raise StandardError::ArgumentError unless @grapharray
    if params[:nofull]
      render :graph, layout: false
    else
      render :graph
    end
  rescue => e
    if params[:nofull]
      if Rails.env.development?
        render plain: "#{e.message} #{e.backtrace.inspect}"
      else
        render plain: ''
      end
    else
      @grapharray = []
      render :graph
    end
  end

  def admin
  end

  def edit
  end

  def update
    if !params[:password] || params[:password].strip.empty?
      current_user.update params.require(:user).permit(:timezone, :lang, :outdateformat)
    else
      current_user.update params.require(:user).permit(:password, :password_confirmation, :outdateformat, :timezone, :lang)
    end 
    flash.now[:success] = t('messages.success.update') if current_user.errors.empty?
    render 'edit'
  end

  def new
    if params[:wallet]
      @wallet = Wallet.new(wallet_perm)
      @wallet.user = current_user
      if @wallet.save
        initval
      else
        @tag = Tag.new
        @tag.checkcolor
      end
    end
    if params[:tag]
      @tag = Tag.new(tag_perm)
      @tag.user = current_user
      if @tag.save
        initval
      else
        @wallet = Wallet.new
      end
    end
    render :edit
  end

  def export
    @items = current_user.items.getpagewithfilters(current_user, MainPagesHelper::getcurrentfilter(params))[0]
    data = []
    @items.each do |it|
      data << {name: it.name, value: it.value, wallet: it.wallet.name, wcurrency: it.wallet.currency, date: it.created_at, tags: it.tags_s} 
    end
    send_data({version: 15, data: data}.to_json, filename: "#{Time.now.strftime('%Y%m%d-%H%M%S')}.json", type: 'application/json')
  end

  def importfile
    if params[:file]
      rfile = params[:file][:importfile]
      if rfile
        begin
          imp = JSON.parse rfile.read
          errors = []
          if imp['version'] === 1
            wimport = current_user.wallets.find params[:file][:wallet_id]
            wimport ||= current_user.defaultwallet
            imp['data'].each do |item|
              it = Item.new(user: current_user, wallet: wimport)
              it.name = item['description']
              it.value = (item['value'].to_f * 100).to_i
              if item['type'] == '0'
                it.value = -it.value
              end
              it.created_at = current_user.localtimezone.local_to_utc Time.strptime("#{item['date']} +0000", "%Y-%m-%d %H:%M:%S %z")
              it.tags = gettags(item['tags'], current_user)
              unless it.save
                errors << it.errors
              end
            end
            redirect_to root_path
            return
          elsif imp['version'] === 15
            imp['data'].each do |item|
              wimport = current_user.wallets.find_by(name: item['wallet'], currency: item['wcurrency'])
              wimport ||= Wallet.new(user: current_user, name: item['wallet'], currency: item['wcurrency'])
              it = Item.new(user: current_user, wallet: wimport)
              it.name = item['name']
              it.value = item['value']
              it.created_at = item['date']
              it.tags = gettags(item['tags'], current_user)
              unless it.save
                errors << it.errors
              end
            end
            redirect_to root_path
            return
          else
            flash.now[:danger] = t('messages.error.incompatible_version')
          end
        rescue JSON::ParserError
          flash.now[:danger] = t('messages.error.incompatible_format')
        end
      end
    end
    initval
    render :edit
  end

  private
    def wallet_perm
      params.require(:wallet).permit(:name, :currency)
    end

    def tag_perm
      params.require(:tag).permit(:name, :color)
    end

    def initval
      @wallet = Wallet.new
      @tag = Tag.new
      @tag.checkcolor
    end

    def rendercharts(items)
      par = MainPagesHelper::getcurrentfilter(params)[:wallet]
      if !par || par.empty?
        wallets = current_user.wallets.ids
      else
        wallets = MainPagesHelper::paramarray(par)
      end

      res = []
      max = items.maximum(:created_at)
      min = items.minimum(:created_at)
      if max && min
        dif = max - min
      else
        dif = 0
      end
      if dif > 1.year
        dif = :year
        @title = t('ui.graph.title.yearly')
      elsif dif > 1.month
        dif = :month
        @title = t('ui.graph.title.monthly')
      else
        dif = :day
        @title = t('ui.graph.title.daily')
      end

      wallets.each do |w|
        resi = items.getgraphdata(w, dif)
        next if resi.empty?
        res << {name: current_user.wallets.find(w).name, data: resi.sort.to_h}
      end
      res.sort{|v1,v2| v1[:data].keys.first<=>v2[:data].keys.first}
    end
end
