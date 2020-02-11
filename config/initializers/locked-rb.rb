Locked.configure do |config|
  # Same as setting it through Locked.api_key
  ##################################
  #
  # api_keyを変更したら、dockerを立ち上げ直してね！！！！！！！！！
  #
  ##################################
  config.api_key = 'ce29e4977346f3070ff61c4a4026' #各自で変更

  # For authenticate method you can set failover strategies: deny (default), allow, verify, throw
  config.failover_strategy = :deny

  # Locked::RequestError is raised when timing out in milliseconds (default: 1000 milliseconds)
  config.request_timeout = 10000

  # Whitelisted and Blacklisted headers are case insensitive and allow to use _ and - as a separator, http prefixes are removed
  # Whitelisted headers
  config.whitelisted = ['X_HEADER']
  # or append to default
  config.whitelisted += ['http-x-header']

  # Blacklisted headers take advantage over whitelisted elements
  config.blacklisted = ['HTTP-X-header']
  # or append to default
  config.blacklisted += ['X_HEADER']
  # config.host = 'stg.locked.jp'
  # config.port = 443
end
