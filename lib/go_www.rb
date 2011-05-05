module GoWww
  def self.included(base)
    base.extend(ClassMethods)
    base.before_filter(:ensure_www)
  end

  module ClassMethods
  end
  
end
