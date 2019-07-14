# frozen_string_literal: true

module Locked
  module LockedClient
    def locked
      @locked ||= request.env['locked'] || Locked::Client.from_request(request)
    end
  end

  ActiveSupport.on_load(:action_controller) do
    include LockedClient
  end
end
