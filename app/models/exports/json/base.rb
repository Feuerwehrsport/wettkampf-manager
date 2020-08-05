# frozen_string_literal: true

module Exports::JSON::Base
  include Exports::Base
  extend ActiveSupport::Concern

  class_methods do
    def perform(*args)
      new(*args)
    end
  end

  def bytestream
    @bytestream ||= to_hash.to_json
  end
end
