module GDash
  class Widget < Base
    class << self
      def inherited subclass
        Section.send :define_method, subclass.name.to_s.demodulize.underscore do |*args, &block|
          add_widget subclass.new(*args, &block)
        end
      end
    end
  end
end