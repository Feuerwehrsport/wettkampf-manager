module TranslationHelper
  def keep_context
    @enforced_virtual_path = @virtual_path
    return_value = yield
    @enforced_virtual_path = nil
    return_value
  end

  def translate(*args)
    virtual_path_backup = @virtual_path
    @virtual_path = @enforced_virtual_path if @enforced_virtual_path
    output = super(*args)
    @virtual_path = virtual_path_backup
    output
  end
  alias :t :translate

  def translate_or_use(sym_or_string)
    if sym_or_string.kind_of?(Symbol)
      t(".#{sym_or_string.to_s}")
    else
      sym_or_string
    end
  end
end