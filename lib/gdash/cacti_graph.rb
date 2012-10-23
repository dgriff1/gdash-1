module GDash
  class CactiGraph < Widget
    attr_accessor :graph_id, :rra_id

    def to_url
      params = window.cacti_params || {}
      params = params.merge(:action => "view", :local_graph_id => graph_id, :rra_id => rra_id)
      params = params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join "&"
      "#{data_center.cacti_host}/graph_image.php?#{params}"
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      html.img :src => to_url.to_sym
    end
  end
end