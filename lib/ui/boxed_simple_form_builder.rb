module UI
  class BoxedSimpleFormBuilder < SimpleForm::FormBuilder
    include StoreOrReturn

    def store_or_return_methods
      [:inputs, :actions]
    end
  end
end