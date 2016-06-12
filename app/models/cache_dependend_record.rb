class CacheDependendRecord < ActiveRecord::Base
  self.abstract_class = true

  after_save :clean_cache
  after_destroy :clean_cache

  private

  def clean_cache
    Rails.cache.clear
    ModelCache.clean
  end
end