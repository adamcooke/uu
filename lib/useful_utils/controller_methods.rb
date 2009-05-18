module UsefulUtils
  
  ## Methods for use within controller actions.
  module ControllerMethods
    ## Flash and redirect. Useful in respond to blocks when you want to be consise and don't want to specify two
    ## seperate lines and break out into a full block.
    ##
    ## For example:
    ##   respond_to do |wants|
    ##      wants.html { flash_redirect :notice, 'Done', @page }
    ##   end
    def flash_redirect(flash_type, flash_message, path)
      flash[flash_type] = flash_message
      redirect_to path
    end
  end

end
ActionController::Base.send :include, UsefulUtils::ControllerMethods
