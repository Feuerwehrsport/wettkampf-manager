module UI
  class BoxBuilder
    include StoreOrReturn

    def store_or_return_methods
      [:footer, :header]
    end
  end
end