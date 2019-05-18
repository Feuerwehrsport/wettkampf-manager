module Exports::Base
  extend ActiveSupport::Concern

  included do
    delegate :t, :l, to: I18n
  end

  protected

  def title
    @title
  end

  def competition
    @competition ||= Competition.one
  end
end
