if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => 'AWS',     # 例: 'ap-northeast-1'
      :aws_access_key_id     => 'AWS',
      :aws_secret_access_key => 'AWS',
    }
    config.fog_directory     =  'AWS'
  end
end
