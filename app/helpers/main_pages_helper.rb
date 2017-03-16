module MainPagesHelper

  DATEFORMATS = ['%Y-%m-%d', '%Y/%m/%d', '%Y.%m.%d', '%d-%m-%Y', '%d/%m/%Y', '%d.%m.%Y', '%m-%d-%Y', '%m/%d/%Y', '%m.%d.%Y']

  def error_messages!(usr)
    return if usr.errors.empty?
    messages = usr.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => usr.errors.count,
                      :resource => usr.class.model_name.human.downcase)
p messages
    html = <<-HTML
    <div id="has-error">
      <h3>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def timezones_regions
    return @regions.keys.sort if @regions
    @regions = {}
    @regions_woffset = {}
    Timezone.names.each do |tmz|
      reg, *city = tmz.split('/')
      next unless reg && tmz
      if !city
        city = ''
      else
        city = city.join('/')
      end
      etc = reg == 'Etc'
      unless etc
        tz = Timezone.fetch(tmz)
        if tz.utc_offset.zero?
          offs = ''
        else
          offs = "#{tz.utc_offset>0?'+':''}#{tz.utc_offset/(60.0*60)}H"
        end
      end
      cityabout = begin
                    if city.empty?
                      c = reg
                    else
                      c = city.gsub('_',' ')
                    end
                    etc ? c : "#{c} #{offs}"
                  end
      if @regions.has_key? reg
        @regions[reg] << city
        @regions_woffset[reg][city] = cityabout
      else
        @regions[reg] = [city]
        @regions_woffset[reg] = {city => cityabout}
      end
    end
    @regions.keys.sort
  end
  
  def timezones_regions_woffset(reg, city)
    @regions_woffset[reg][city]
  end

  def timezones_cities(region)
    return @regions[region].sort if @regions
    timezones_regions
    @regions[region].sort
  end

  def self.paramarray(param)
    param.split('|').map { |v|
      v.strip!
      begin
        v.empty? ? nil : v.to_i
      ensure
        nil
      end
    }.compact
  end

  DEFAULT_PARAMETERS = [:wallet, :tag, :dir, :search, :datestart, :dateend]

  def self.getcurrentfilter(params, wout=nil)
    return params.permit(DEFAULT_PARAMETERS) unless wout
    s = DEFAULT_PARAMETERS - wout
    params.permit(s)
  end

  def paramslink(options={})
    @plink ||= MainPagesHelper::getcurrentfilter(params)
    vr = @plink.to_h
    options.each do |k, v|
      next if k == :add || k == :remove || k == :forceremove || k == :path
      if options[:add] && vr.has_key?(k)
        unless vr[k] =~ /(\||^)#{v}(\||$)/
          vr[k] += "|#{v}"
        end
      elsif options[:remove] && vr.has_key?(k)
        if options[:forceremove]
          vr[k] = nil
        else
          vr[k] = (MainPagesHelper::paramarray(vr[k]) - MainPagesHelper::paramarray(v)).join('|')
        end
      else
        vr[k] = v
      end
      vr.delete(k) unless vr[k] && !vr[k].empty?
    end
    path = options[:path] || root_path
    vr.keys.reduce("#{path}?") do |s, k|
      "#{s}#{k}=#{vr[k].gsub('|', '%7C')}&"
    end
  end
end
