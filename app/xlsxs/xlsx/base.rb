module XLSX::Base
  extend ActiveSupport::Concern

  class_methods do
    def perform(*args)
      instance = new(*args)
      instance.perform
      instance
    end
  end

  included do
    delegate :t, :l, to: I18n
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

  def title
    @title
  end

  def competition
    @competition ||= Competition.one
  end
end
