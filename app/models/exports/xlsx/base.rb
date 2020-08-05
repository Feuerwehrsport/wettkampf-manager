# frozen_string_literal: true

module Exports::XLSX::Base
  include Exports::Base
  extend ActiveSupport::Concern

  class_methods do
    def perform(*args)
      instance = new(*args)
      instance.perform
      instance
    end
  end

  def bytestream
    @bytestream ||= package.to_stream.read
  end

  protected

  def package
    @package ||= Axlsx::Package.new
  end

  def workbook
    @workbook ||= package.workbook
  end
end
