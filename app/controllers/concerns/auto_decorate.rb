module AutoDecorate
  def render(*args)
    auto_decorate
    super
  end

  private

  def auto_decorate
    if collection_instance && collection_instance.respond_to?(:decorate)
      self.collection_instance = collection_instance.decorate
    end
    self.resource_instance = resource_instance.decorate if resource_instance && resource_instance.respond_to?(:decorate)
  end
end
