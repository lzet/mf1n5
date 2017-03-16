class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  before_action :setlocal
  
  private
    def setlocal
      if user_signed_in?
        I18n.locale = current_user.locale
        cookies.permanent[:lang] = current_user.locale
      else
        I18n.locale = cookies[:lang]
      end
    rescue
      I18n.locale = :en
    end
end
