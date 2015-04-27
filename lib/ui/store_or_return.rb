module UI
  module StoreOrReturn
    def respond_to?(method)
      super || store_or_return_method?(method)
    end

    def method_missing(method, *args, &block)
      return super unless store_or_return_method?(method)
      if block
        store_or_return_storage[method] = block
        nil
      elsif args.length == 1
        store_or_return_storage[method] = args.first
        nil
      else
        store_or_return_storage[method]
      end
    end

    def store_or_return_storage
      @store_or_return_storage ||= {}
    end

    protected

    def store_or_return_methods
      []
    end

    private

    def store_or_return_method?(method)
      store_or_return_methods.include?(method.to_sym)
    end
  end
end