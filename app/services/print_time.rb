class PrintTime
  def initialize(object)
    @object = object
  end

  def time_posted
    @object.created_at.strftime("Posted at %H:%M %F")
  end
end
