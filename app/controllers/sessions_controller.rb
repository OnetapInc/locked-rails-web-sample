require 'locked/support/rails'
class SessionsController < ApplicationController
  # GET /login
  def new
    #@session = Session.new
  end

  # GET /verify
  def verify
    #@session = Session.new
  end

  # GET /load
  def load
    user = User.where('locked_token_expired_at > ?', Time.zone.now).find_by(locked_token: params[:token])
    if user && user.activated?
      log_in user
      remember(user)
      redirect_to user
    else
      flash[:warning] = "アカウント情報の読み込みに失敗しました"
      redirect_to root_url
    end
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # Success
        result = nil
        begin
          result = locked.authenticate(
            event: '$login.attempt',
            user_id: "user#{user.id}",
            user_ip: request.remote_ip,
            user_agent: request.user_agent,
            email: user.email,
            callback_url: 'http://0.0.0.0:3000/load'
          )
        rescue Locked::Error => e
          puts e.message
        end
        case result[:data][:action]
        when 'none'
          p '診断モードです'
        when 'allow'
          p 'allowです'
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or user
        when 'verify'
          p 'verifyです'
          user.update!(
            locked_token: result[:data][:verify_token],
            locked_token_expired_at: Time.zone.now + 1.hour
          )
          render 'verify'
        when 'deny'
          p 'denyです'
          flash.now[:danger] = '不正ログインの可能性が高いため、ログインできませんでした'
          render 'new'
        end

      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Failure
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
