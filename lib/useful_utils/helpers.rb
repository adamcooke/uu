module UsefulUtils
    
  ## Methods for use within views and layouts
  module Helpers
    
    ## Flash all flash messages whhcv have been stored.
    def display_flash
      flashes = flash.collect do |key,msg|
      	content_tag :div, content_tag(:p, msg), :id => "flash-#{key}"
      end.join
    end
    
    def stripe
      cycle 'o', 'e'
    end
  
    def icon_tag(icon, text = '')
      extension = (icon.is_a?(Symbol) ? ".png" : '')
      image_tag "icons/#{icon.to_s}#{extension}", :alt => text, :title => text, :class => "icon #{icon}"
    end

    def timestamp(time)
      return "" unless time.is_a?(Time)
      if time.utc < (Time.now - 4.days)
        r = time.strftime("%d %b %y")
      else
        r = distance_of_time_in_words_to_now(time) + " "
        r << (time < Time.now ? "ago" : "from now")
      end
      content_tag(:span, r, :title => time.rfc822, :class => "timestamp")
    end

    def req
      %Q{<span class="req" title="#{t('required_field')}">*</span>}
    end

    def avatar_for(email, size = 35)
      image_tag("http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&rating=PG&size=#{size}&d=identicon", :class => 'avatar', :width => size, :height => size)
    end
  
    def time_of_day(time = Time.now)
      hour = time.hour
      if hour >= 0 and hour <= 12
        return :morning
      elsif hour >= 13 and hour <= 18
        return :afternoon
      else
        return :evening
      end
    end

  end
  
end
ActionView::Base.send :include, UsefulUtils::Helpers
