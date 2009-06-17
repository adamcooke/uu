class String
  
  ## Return a random alpha-numeric string
  def self.random(length = 20)
    srand
    options = { :length => length, :chars => ('a'..'z').to_a + ('0'..'9').to_a }
    Array.new(options[:length]) { options[:chars].to_a[rand(options[:chars].to_a.size)] }.join
  end
  
  ## Create a sha for this string
  def to_sha(length = 40)
    Digest::SHA1.hexdigest(self)[0,length]
  end
    
  ## Create a permalink
  def to_permalink(space_character = '-')
    p = self.dup
    p.downcase!
    p.gsub!(" ", space_character)
    p.gsub!(/[^\w+|\-]/, "")
    p.strip!
    p
  end
  
  def enclose(c)
    case c
    when '()' then "(#{self})"
    when '[]' then "[#{self}]"
    else
      "#{c}#{self}#{c}"
    end
  end
  
end

class Hash

  def except(*blacklist)
    self.reject {|key, value| blacklist.include?(key || key.to_sym) }
  end

  def only(*whitelist)
    self.reject {|key, value| !whitelist.include?(key || key.to_sym) }
  end

  def deep_clone
    Marshal::load(Marshal.dump(self))
  end
  
  def stringify_values
    inject({}) do |options, (k,v)|
      options[k] = v.to_s
      options
    end
  end
  
end
