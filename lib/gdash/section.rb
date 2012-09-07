module GDash
  class Section < Widget
    attr_accessor :title, :width

    def initialize *args, &block
      @width = 3
      super
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      html.div :class => "row" do
        html.h3 title
        html.table do
          child_groups(3).each do |group|
            html.tr do
              group.each do |child|
                html.td do
                  child.to_html html
                end
              end
            end
          end
        end
      end
    end
  end
end