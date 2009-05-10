module UsefulUtils
  
  ## Prodvides basic functionality for identifying user agents by operating system, browser and browser
  ## version. 
  
  module Agent
    
    ## Returns the agent operating system 
    
    def client_os
      return 'generic_os' unless request.env['HTTP_USER_AGENT']
       agent = request.env['HTTP_USER_AGENT'].downcase
       [:windows, :macintosh, :linux].each do |os|
         return os if agent.include?(os.to_s)
       end
       return 'generic_os'
     end
     
     ## Returns the agent browser

     def client_browser
       return 'generic_browser' unless request.env['HTTP_USER_AGENT']
       agent = request.env['HTTP_USER_AGENT'].downcase
       [:chrome, :safari, :firefox, :msie].each do |b|
         return b if agent.include?(b.to_s)
       end
       return 'generic_browser'
     end
     
     ## Returns the agent's browser version and browser name joined together

     def client_browser_version
       return '' unless request.env['HTTP_USER_AGENT']
       agent = request.env['HTTP_USER_AGENT'].downcase
       browser = client_browser
       match = case browser
       when :firefox then agent.match(/firefox\/(\d)/)
       when :safari then agent.match(/version\/(\d).* safari/)
       when :msie then agent.match(/compatible; msie (\d)(\..*);/)
       end
       match ? [browser.to_s, match[1].to_s].join.to_sym : nil
     end

     ## Join together os, browser and version to create a string appropriate for use in
     ## an HTML body tag.

     def user_agent_tag
       [client_os.to_s, client_browser.to_s, client_browser_version.to_s].join(' ')
     end
   
     def self.included(base) #:nodoc:
       base.send :helper_method, :user_agent_tag
     end
  end
end

ActionController::Base.send :include, UsefulUtils::Agent
