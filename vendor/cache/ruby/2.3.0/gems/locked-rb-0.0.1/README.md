# locked-ruby

[Locked](https://locked.jp) analyzes device, location, and interaction patterns in your web and mobile apps and lets you stop account takeover attacks in real-time..

### Installation

Add the `locked-rb` gem to your `Gemfile`

```
gem 'locked-rb'
```

### Configuration

**Framework configuration**

Load and configure the library with your Locked API key in an initializer or similar.

```
Locked.api_key = 'YOUR_API_KEY'
```

A Locked client instance will be made available as `locked` in your

* Rails controllers when you add require 'locked/support/rails'

* Padrino controllers when you add require 'locked/support/padrino'

* Sinatra app when you add `require 'locked/support/sinatra'` (and additionally explicitly add register `Sinatra::Locked` to your `Sinatra::Base` class if you have a modular application)

```
require 'locked/support/sinatra'

class ApplicationController < Sinatra::Base
  register Sinatra::Locked
end
```

* Hanami when you add require 'locked/support/hanami' and include Locked::Hanami to your Hanami application
require 'locked/support/hanami'

```
module Web
  class Application < Hanami::Application
    include Locked::Hanami
  end
end
```

### Client configuration
Configure the library in an initializer or similar.
```
Locked.configure do |config|
  # Same as setting it through Locked.api_key
  config.api_key = 'key'

  # For authenticate method you can set failover strategies: deny (default), allow, verify, throw
  config.failover_strategy = :deny

  # Locked::RequestError is raised when timing out in milliseconds (default: 1000 milliseconds)
  config.request_timeout = 2000

  # Whitelisted and Blacklisted headers are case insensitive and allow to use _ and - as a separator, http prefixes are removed
  # Whitelisted headers
  config.whitelisted = ['X_HEADER']
  # or append to default
  config.whitelisted += ['http-x-header']

  # Blacklisted headers take advantage over whitelisted elements
  config.blacklisted = ['HTTP-X-header']
  # or append to default
  config.blacklisted += ['X_HEADER']
end
```

### Authenticating login request

Here is a simple example of authenticating request. The method `locked` is already included in Rails controllers.
```
begin
  locked.authenticate(
    event: '$login.success',
    user_id: 1234,
    user_ip: '1.1.1.1',
    user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063',
    email: 'example@locked.jp',
    callback_url: 'https://locked.jp/login/result'
  )
rescue Locked::Error => e
  puts e.message
end
```

When using plain Ruby, configure the `Locked` module and initiate a `Locked::Client` instance to use `authenticate` method
```
require 'locked-rb'
Locked.configure do |config|
  config.api_key = 'key'
end
client = Locked::Client.new({})
client.authenticate(
  event: '$login.success',
  user_id: 1234,
  user_ip: '1.1.1.1',
  user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063',
  email: 'example@locked.jp',
  callback_url: 'https://locked.jp/login/result'
)
```

And a possible response
```
{
  success: true,
  status: 200,
  data: {
    action: verify,
    verify_token: 'f7e11d023c78'
  }
}
```

When a user is required to verify his/her login, a `verify_token` is return so that later on your system can identify that user's login session.

### Exceptions

`Locked::Error` will be thrown if the Locked API returns a 400 or a 500 level HTTP response.
