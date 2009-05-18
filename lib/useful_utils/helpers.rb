module UsefulUtils
    
  ## Methods for use within views and layouts
  module Helpers
    
    ## Flash all flash messages whhcv have been stored.
    def display_flash
      flashes = flash.collect do |key,msg|
      	content_tag :div, content_tag(:p, msg), :id => "flash-#{key}"
      end.join
    end
        
  end
  
end
ActionView::Base.send :include, UsefulUtils::Helpers
