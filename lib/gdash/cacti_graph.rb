module GDash
  class CactiGraph < Widget
    attr_accessor :graph_id, :rrd_id

    def to_url
      params = { :action => "view", :local_graph_id => graph_id, :rrd_id => rrd_id }.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&")
      "#{cacti_host}/graph_image.php?#{params}"
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      html.img :src => to_url.to_sym
    end
  end
end