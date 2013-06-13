module GDash
  class Page < Base
    attr :refresh, :default => 60

    collection :children, :default => []
    collection :sections, :default => []

    [:tab_set, :section, :nagios].each do |widget|
      define_method widget do |*args, &block|
        add_child GDash.const_get(widget.to_s.camelize).new(*args, &block)
      end
    end

    def <=> other
      (title || "") <=> ((other && other.title) || "")
    end

    private

    def add_child obj
      @children ||= []
      @children << obj unless @children.include?(obj)
      obj
    end
  end
end