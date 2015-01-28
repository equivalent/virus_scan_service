Struct.new('NullLogger') do
  def info(*)
    nil
  end

  def debug(*)
    nil
  end
end
