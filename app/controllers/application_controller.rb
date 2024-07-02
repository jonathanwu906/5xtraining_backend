# frozen_string_literal: true

# ApplicationController is the parent class of all controllers in the application
class ApplicationController < ActionController::Base
  include SessionsHelper

  def require_login
    return if logged_in?

    flash[:alert] = I18n.t('sessions.require_login')
    redirect_to login_path
  end
end
