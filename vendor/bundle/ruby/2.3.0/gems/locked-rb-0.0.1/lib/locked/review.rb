# frozen_string_literal: true

module Locked
  class Review
    def self.retrieve(review_id)
      Locked::API.request(
        Locked::Commands::Review.build(review_id)
      )
    end
  end
end
