# frozen_string_literal: true

module Locked
  module Commands
    class Review
      class << self
        def build(review_id)
          Locked::Validators::Present.call({ review_id: review_id }, %i[review_id])
          Locked::Command.new("reviews/#{review_id}", nil, :get)
        end
      end
    end
  end
end
