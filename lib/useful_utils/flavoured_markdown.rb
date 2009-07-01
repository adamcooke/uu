module UsefulUtils
  module AtechFlavouredMarkdown
    
    def afm(content, options = {})
      options[:preserve] = options[:preserve].nil? ? true : options[:preserve]
      options[:sanitize] = options[:sanitize].nil? ? false : options[:sanitize]
      options[:remove_quote_lines] = options[:remove_quote_lines].nil? ? true : options[:remove_quote_lines]
      options[:format_inline_images] = options[:format_inline_images].nil? ? false : options[:format_inline_images]

      content = sanitize(content) if options[:sanitize]

      if options[:remove_quote_lines]
        content = content.gsub(/On(.*) wrote:/, '')
      end

      if options[:format_inline_images]
        #content = "Hello"
        content.gsub!(/!\[Image(\d+)?\]\((.*)\)/) { content_tag(:p, image_tag($2, :alt => "Image", :width => $1), :class => "image") }
      end

      content = content.strip.chomp

      bc = BlueCloth.new(content)
      content = (options[:preserve] ? preserve(bc.to_html) : bc.to_html)
      content_tag :div, content, :class => 'cfm'
    end
    
  end
end

ActionView::Base.send :include, UsefulUtils::AtechFlavouredMarkdown
