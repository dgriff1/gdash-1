module GDash
  class Dashboard < Named
    attr :refresh, :default => 60

    collection :windows, :default => Window.all
    collection :pages, :class => Page

    alias_method :old_windows, :windows

    def find page
      pages.select { |p| p.name == page.to_s }.first
    end

    def windows *args, &block
      old_windows(*args, &block).sort
    end

    def custom_window *args, &block
      w = Window.new(*args, &block)
      self.window w
      w
    end

    def <=> other
      (title || "") <=> ((other && other.title) || "")
    end
  end
end