module GDash
  class Section < Base
    attr :width, :default => 3
    collection :widgets

    def add_widget widget
      @widgets ||= []
      @widgets << widget
      widget
    end
  end
end