module GDash
  class Scope
    def initialize parent = nil, options = {}
      @parent = parent
      @options = options
    end

    def method_missing name, *args
      @options[name] || (@parent && @parent.send(name))
    end

    def to_hash
      (@parent ? @parent.to_hash : {}).merge @options
    end
  end
end