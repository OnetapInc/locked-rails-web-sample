# frozen_string_literal: true

require 'locked/support/rails'
class SessionsController < ApplicationController
  # GET /login
  def new
    # @session = Session.new
  end

  # GET /verify
  def verify
    # @session = Session.new
  end

  # GET /load
  def load
    user = User.where('locked_token_expired_at > ?', Time.zone.now).find_by(locked_token: params[:token])
    if user&.activated?
      log_in user
      remember(user)
      redirect_to user
    else
      flash[:warning] = 'アカウント情報の読み込みに失敗しました'
      redirect_to root_url
    end
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email])
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    redirect_back_or user
  end

  # POST /authenticate_login
  def authenticate_login_create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      if user.activated?
        # Success
        result = nil
        begin
          result = locked_authenticate(user)
        rescue Locked::Error => e
          puts e.message
        end
        case result[:data][:action]
        when 'none'
          authenticate_none
          redirect_to authenticate_login_url
        when 'allow'
          authenticate_allow
        when 'verify'
          authenticate_verify(result, user)
          render 'verify'
        when 'deny'
          authenticate_deny
          render 'authenticate_login'
        end
      else
        not_activated
      end
    else
      # Failure
      flash.now[:danger] = 'Invalid email/password combination'
      render 'authenticate_login'
    end
  end

  # POST /diagnosis_login
  def diagnosis_login_create
    user = User.find_by(email: params[:session][:email])
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    set_diagnosis_logined_html_param(user)
    render_diagnosis_logined_page
  end

  # POST /only_verdict_login
  def only_verdict_login_create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      if user.activated?
        # Success
        result = nil
        begin
          result = locked_authenticate(user)
        rescue Locked::Error => e
          puts e.message
        end
        case result[:data][:action]
        when 'none'
          authenticate_none
          redirect_to only_verdict_login_url
        when 'allow'
          authenticate_allow
        when 'verify'
          authenticate_verify(result, user)
          set_only_verdict_verify_html_param(user)
          render 'only_verdict_verify'
        when 'deny'
          authenticate_deny
          render 'only_verdict_login'
        end
      else
        not_activated
      end
    else
      # Failure
      flash.now[:danger] = 'Invalid email/password combination'
      render 'only_verdict_login'
    end
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def locked_authenticate(user)
    locked.authenticate(
      locked_authenticate_params(user)
    )
  end

  def locked_authenticate_params(user)
    {
      event: '$login.attempt',
      user_id: "user#{user.id}",
      user_ip: request.remote_ip, # localhostのipaddressで不具合があるときは固定値を設定する '223.218.185.134'
      user_agent: request.user_agent,
      email: user.email,
      callback_url: 'https://rails-locked-sample.herokuapp.com/load'
    }
  end

  def authenticate_allow
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    redirect_back_or user
  end

  def authenticate_verify(result, user)
    user.update!(
      locked_token: result[:data][:verify_token],
      locked_token_expired_at: Time.zone.now + 1.hour
    )
  end

  def authenticate_deny
    flash.now[:danger] = '不正ログインの可能性が高いため、ログインできませんでした'
  end

  def authenticate_none
    message = '認証モードにしてください。診断モードでは利用できません。'
    flash[:warning] = message
  end

  def render_diagnosis_logined_page
    if params[:diagnosis] # name attributes
      render 'diagnosis/diagnosis_logined'
    elsif params[:diagnosis_encrypt]
      render 'diagnosis/diagnosis_encrypt_logined'
    end
  end

  def not_activated
    message  = 'Account not activated. '
    message += 'Check your email for the activation link.'
    flash[:warning] = message
    redirect_to root_url
  end

  def set_only_verdict_verify_html_param(user)
    @result = locked_authenticate_params(user)
    @user = user
  end

  def set_diagnosis_logined_html_param(user)
    @user = user
  end
end
