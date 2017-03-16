module ApplicationHelper
  LANGUAGES = {en: 'English', ru: 'Русский'}

  def icon_tag(icon_name)
    "<i class='icon #{icon_name}'></i>".html_safe
  end

  def admin_check
    raise ActionController::RoutingError.new "Not found" unless user_signed_in?
    raise ActionController::RoutingError.new "Not found" unless current_user.admin?
  end

  def getsubtitle(*args)
    r = ""
    args.each_slice(2) do |v|
      break if v.size != 2
      r += "<li><a href=#{v[1]}>#{v[0]}</a></li>\n"
    end
    r.html_safe
  end

  def signed_in_check
    redirect_to new_user_session_path unless user_signed_in?
  end

  def gettags(ts, cuser)
    restags = []
    if ts && !ts.empty?
      ts.split(',').each do |tagstr|
        tstr = tagstr.strip
        if !tstr.empty?
          newt = cuser.tags.find_by(name: tstr)
          newt ||= Tag.create(name: tstr, user: cuser)
          restags << newt if newt
        end
      end
    end
    restags
  end
end
