module GDash
  class Nagios < Widget
    attr_accessor :host_group, :username, :password
    
    def initialize host_group, *args, &block
      self.host_group = host_group
      super *args, &block
    end
    
    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      
      
    end
    
    def name
      doc.css("")
    end
    
    def hosts_up
      Integer(doc.css(".miniStatusUP > a").first.content.gsub(/\D/, ''))
    end
    
    def hosts_down
      Integer(doc.css(".miniStatusDOWN > a").first.content.gsub(/\D/, ''))
    end
    
    private
    
    def doc
      @doc ||= Nokogiri::HTML(open("#{nagios_host}/cgi-bin/status.cgi?hostgroup=#{host_group}&style=summary&noheader", :http_basic_authentication => [username, password]))
    end
  end
end