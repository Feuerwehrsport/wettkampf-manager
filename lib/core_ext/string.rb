class String
  def truncate_bytes(limit, options = {})
    orig_limit = limit
    new_string = nil
    loop do
      new_string = truncate(limit, options)
      limit -= 1
      break unless new_string.bytes.count > orig_limit
    end
    new_string
  end
end
