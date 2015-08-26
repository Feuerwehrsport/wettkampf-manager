module ClearCacheOnSave
  extend ActiveSupport::Concern
  included do
    after_save :clear_rails_cache
    after_destroy :clear_rails_cache
  end

  protected

  def cache_name
    "#{self.class.table_name}--#{id}"
  end

  def cache_fetch(key="", &block)
    Rails.cache.fetch("#{cache_name}--#{key}", &block)
  end

  private 

  def clear_rails_cache
    Rails.cache.clear
  end
end