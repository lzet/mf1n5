class Item < ApplicationRecord
  include ApplicationHelper

  has_many :descriptions
  has_many :tags, through: :descriptions
  belongs_to :wallet
  belongs_to :user
  validates :name, length: { minimum: 1 },
                   presence: true
  validates :value, presence: true
  validates :user_id, presence: true

  after_save :changewallet
  after_destroy :backwallet

  TIMEFORMAT = '%H:%M'
  DATEFORMAT = '%Y-%m-%d'

  scope :itemsandpagecount, ->(user, limit, page, param) {
    itemswfilter, hasfilter = getpagewithfilters(user, param)
    pagecnt = itemswfilter.count/limit
    page = pagecnt if page > pagecnt
    total = nil
    if hasfilter
      total = {}
      user.wallets.each do |w|
        s1 = itemswfilter.where(wallet: w).where('items.value > 0').sum(:value)
        s2 = itemswfilter.where(wallet: w).where('items.value < 0').sum(:value)
        if s1 && s1 != 0
          s1 = s1/100.0
        else
          s1 = 0
        end
        if s2 && s2 != 0
          s2 = s2/100.0
        else
          s2 = 0
        end
        if s1 != 0 || s2 != 0
          total[w] = [s1, s2]
        end
      end
    end
    return itemswfilter.order(created_at: :desc).limit(limit).offset(page*limit), pagecnt, page, total
  }

  scope :getpagewithfilters, ->(user=nil, param={}){
    r = includes(:wallet, :tags)
    hasfilter = false
    if param[:dir]
      dir = MainPagesHelper::paramarray(param[:dir])
      if !dir.empty? && dir.length == 1
        hasfilter = true
        if dir[0] == 0
          r = r.where('"items"."value" >= 0')
        else
          r = r.where('"items"."value" < 0')
        end
      end
    end
    if param[:search]
      hasfilter = true
      r = r.where('"items"."name" LIKE ?', "%#{param[:search]}%")
    end
    if param[:datestart] && param[:dateend]
      begin
        dt1 = user.localtimezone.local_to_utc(Time.strptime(param[:datestart], DATEFORMAT))
        dt2 = user.localtimezone.local_to_utc(Time.strptime(param[:dateend], DATEFORMAT)) + 24.hours
        r = r.where(created_at: dt1..dt2)
        hasfilter = true
      rescue
      end
    end
    if param[:wallet]
      hasfilter = true
      r = r.where(wallet: MainPagesHelper::paramarray(param[:wallet]))
    end
    if param[:tag]
      hasfilter = true
      r = r.where(descriptions: {tag_id: MainPagesHelper::paramarray(param[:tag])})
    end
    return r, hasfilter
  }

  scope :getgraphdata, ->(wallet, period){
    resi = where(wallet: wallet)
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      ord = "to_char(items.created_at, 'YYYY')"
      case period
      when :day
        ord = "to_char(items.created_at, 'YYYY-MM-DD')"
      when :month
        ord = "to_char(items.created_at, 'YYYY-MM')"
      end
      resi = resi.select(ord).group(ord)
    else
      case period
      when :day
        resi = resi.group_by_day(:created_at)
      when :month
        resi = resi.group_by_month(:created_at)
      else
        resi = resi.group_by_year(:created_at)
      end
    end
    resi = resi.sum('items.value/100.0')
  }

  def extinit(current_user, param={})
    self.user_id = current_user.id
    self.name = param[:name]
    self.wallet_id = param[:wallet_id]
    if param[:tags_s]
      self.tags = gettags(param[:tags_s], current_user)
    end
    if param[:date] && param[:time]
      begin
        @tm = param[:time]
        @dt = param[:date]
        self.created_at = current_user.localtimezone.local_to_utc Time.strptime("#{param[:date]} #{param[:time]} +0000", "#{DATEFORMAT} #{TIMEFORMAT} %z")
      rescue ArgumentError
        self.created_at = Time.now.utc
        @tm = nil
        @dt = nil
        self.time
        self.date
      end
    end
    if param[:valueabs]
      if self.id
        @beforeval = self.value
      end
      self.value = param[:valueabs].gsub(',', '.').to_f * 100
      if self.value && param[:checkbox] == 'out'
        self.value *= -1
      end
      self.value = nil if self.value == 0
    end
  end

  def to_s
    "name: #{self.name}\ntags: #{tags_s}\ntime: #{time}\ndate: #{date}\ncreated: #{self.created_at.strftime("#{DATEFORMAT} #{TIMEFORMAT}") if self.created_at}\nchbox: #{checkbox}\nvalue: #{self.value}"
  end

  def time
    return @tm if @tm
    tmcur = self.created_at ? self.created_at : Time.now
    @tm = self.user.localtimezone.utc_to_local(tmcur).strftime(TIMEFORMAT)
  end

  def date
    return @dt if @dt
    tmcur = self.created_at ? self.created_at : Time.now
    @dt = self.user.localtimezone.utc_to_local(tmcur).strftime(DATEFORMAT)
  end

  def date_s
    nw = self.user.localtimezone.utc_to_local(Time.now)
    cre = self.user.localtimezone.utc_to_local(self.created_at)
    format = TIMEFORMAT
    if cre.year != nw.year || cre.month != nw.month || cre.day != nw.day
      format = self.user.outdateformat
    end
    #if cre.year == nw.year
    #  if cre.month == nw.month
    #    if cre > nw - 1.week
    #      unless cre.day == nw.day
    #        format = '%A'
    #      end
    #    else
    #      format = '%e/%b'
    #    end
    #  else
    #    format = '%B'
    #  end
    #else
    #  format = '%Y'
    #end
    self.user.localtimezone.utc_to_local(self.created_at).strftime(format)
  end

  def checkbox
    self.value && self.value > 0 ? 'in' : 'out'
  end

  def tags_s
    return '' if !self.tags || self.tags.empty?
    self.tags.reduce(''){ |r, v| r+v.name+', '}
  end
  
  def valueabs
    return nil unless self.value
    self.value.abs/100.0
  end

  private
    def changewallet #after_save
      @beforeval ||= 0
      self.wallet.value += (self.value - @beforeval)
      self.wallet.save
    end

    def backwallet #after_destroy
      self.wallet.value -= self.value
      self.wallet.save
    end

end
