module GDash
  class Section < Widget
    attr_accessor :title, :width

    def initialize *args, &block
      @width = 3
      super
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      html.div :class => "row-fluid" do
        html.h2 title
        html.table :class => "table" do
          child_groups(width).each do |group|
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