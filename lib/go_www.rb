module GoWww
  def self.included(base)
    base.extend(ClassMethods)
    base.before_filter(:ensure_www)
  end

  module ClassMethods
    def already_www?
      return if request.host.downcase =~ /^(www.)/
    end

    def ensure_www
      if RAILS_ENV == "production" &&  !already_www?
        redirect_to "#{request.protocol + 'www.' + request.host + request.path}"
        flash.keep
        return false
      end
    end
  end
  
end
