class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,# :registerable,
         #:recoverable,
         :rememberable,
         :trackable, :validatable

  has_many :wallets, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :items, dependent: :destroy

  def sortedtags
    tags.sort {|a,b| a.name <=> b.name}
  end

  def admin?
    email == 'admin@admin'
  end

  def wallets_count
    wallets.size
  end
  
  def tags_count
    return 0 unless tags
    tags.size
  end

  def defaultwallet
    return @dwallet if @dwallet
    wallets.each do |w|
      if w.def
        @dwallet = w
        break
      end
    end
    @dwallet ||= wallets.first
  end

  def localtimezone
    @tz ||= Timezone[timezone]
  end

  def curtime
    @ct ||= begin
      localtimezone.utc_to_local(Time.now.utc)
    end
  end

  def datefromparam(valstr)
    v = valstr.to_i
    return "error" if v == 0
    localtimezone.utc_to_local(Time.at(v)).strftime('%Y-%m-%d %H:%M')
  end

  def locale
    lang.to_sym
  end

end
