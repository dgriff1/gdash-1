module GDash
  class TabSet < Base
    attr :tabs, :default => []
    attr :tab_names, :default => {}

    def tab name, *args, &block
      if tab_names.has_key? name
        tab_names[name].yld &block
      else
        tab_names[name] = Tab.new name, *args, &block
        tabs << tab_names[name]
      end

      tab_names[name]
    end
  end
end
