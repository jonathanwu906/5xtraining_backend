# frozen_string_literal: true

# SessionsController handles the login and logout operations
class SessionsController < ApplicationController
  def new; end

  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session
      log_in user
      if user.admin?
        redirect_to admin_root_path
      else
        redirect_to tasks_path
      end
    else
      flash.now[:alert] = I18n.t('sessions.login_failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    session[:user_id] = nil
    flash[:notice] = I18n.t('sessions.logout_success')
    redirect_to login_path, status: :see_other
  end
end