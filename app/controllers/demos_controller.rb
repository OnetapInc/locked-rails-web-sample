# frozen_string_literal: true

class DemosController < ApplicationController

  def index
    @users = User.all
  end

  # GET /login
  def new
    # @session = Session.new
  end

  # GET /verify
  def verify
    # @session = Session.new
  end

  def create
    user = User.find_by(email: params[:demos][:email])

    authenticate_params = {
      user_id: "#{user.name}",
      event: '$login.attempt',
      user_ip: request.remote_ip,
      user_agent: request.user_agent,
      email: user.email,
      callback_url: "http://localhost:3232/demos/load",
      device_uuid: cookies[:_locked_device_uuid],
      fingerprint_hash: cookies[:_locked_hash],
    }

    if user.name.start_with?(/Locked Demo 0/)
      authenticate_params[:sms] = user.phone_number
      authenticate_params[:sms_country_code] = 'JP'
    elsif user.name.start_with?(/Locked Demo 1/)
    elsif  user.name.start_with?(/Locked Demo 2/)
      authenticate_params[:sms] = user.phone_number
      authenticate_params[:sms_country_code] = 'JP'
    elsif  user.name.start_with?(/Locked Demo 3/)
    end
    pp verdict = LockedAuthenticateService.new("ce29e4977346f3070ff61c4a4026", authenticate_params).call
    case verdict[:data][:action]
		when 'allow'
      log_in user
      redirect_back_or user
		when 'verify'
      user.update!(
        locked_token: verdict[:data][:verify_token],
        locked_token_expired_at: Time.zone.now + 1.hour
      )
      render 'verify'
		when 'deny'
      flash.now[:danger] = '不正ログインの可能性が高いため、ログインできませんでした'
      render 'new'
    when 'none'
      log_in user
      redirect_back_or user
		end
  end

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

end
