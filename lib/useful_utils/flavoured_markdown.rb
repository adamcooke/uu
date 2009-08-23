module UsefulUtils
  module AtechFlavouredMarkdown
    
    def afm(content, options = {}, &block)
      options[:preserve] = options[:preserve].nil? ? true : options[:preserve]
      options[:sanitize] = options[:sanitize].nil? ? false : options[:sanitize]
      options[:remove_quote_lines] = options[:remove_quote_lines].nil? ? true : options[:remove_quote_lines]
      options[:format_inline_images] = options[:format_inline_images].nil? ? false : options[:format_inline_images]
      options[:markup] ||= :markdown

      content = sanitize(content) if options[:sanitize]

      if options[:remove_quote_lines]
        content = content.gsub(/On(.*) wrote:/, '')
      end

      if options[:format_inline_images]
        content.gsub!(/!\[Image(\d+)?\]\((.*)\)/) { content_tag(:p, image_tag($2, :alt => "Image", :width => $1), :class => "image") }
      end

      content = content.strip.chomp
      
      content = case options[:markup].to_sym
      when :markdown then BlueCloth.new(content)
      when :textile then RedCloth.new(content)
      when :simple then simple_format(content)
      else
        content
      end
            
      content = (content.respond_to?(:to_html) ? content.to_html : content)

      if options[:preserve]
        content = preserve(content)
      end

      if block_given?
        content = block.call(content)
      end
      
      content_tag :div, content, :class => 'afm cfm'
    end
    
  end
end

ActionView::Base.send :include, UsefulUtils::AtechFlavouredMarkdown
