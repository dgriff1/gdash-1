require "spec_helper"

module GDash
  describe "Index", :type => :request do

    before do
      @context_class = Class.new
      @context = @context_class.new
      @template = Tilt.new(File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. .. lib gdash views index.haml})))
    end

    subject do
      @template.render @context
    end
  end
end