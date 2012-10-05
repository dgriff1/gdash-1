require "spec_helper"

module GDash
  describe "Layout", :type => :request do

    before do
      @context_class = Class.new
      @context = @context_class.new
      @template = Tilt.new(File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. .. lib gdash views layout.haml})))
    end

    subject do
      @template.render @context
    end
  end
end