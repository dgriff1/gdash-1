class Sinatra::Helpers::Stream
  def write *args, &block
    send(:<<, *args, &block)
  end
end

module GDash
  module Snapshot
    class Server < Sinatra::Base
      class << self
        def run address, port, tarball
          STDERR.puts "Creating temp dir"
          Dir.mktmpdir do |dir|
            STDERR.puts "Setting public folder to #{dir.inspect}"
            set :public_folder, dir

            STDERR.puts "Extracting tarball to #{dir.inspect}"
            File.open tarball, "r" do |f|
              zip = Zlib::GzipReader.new f
              Archive::Tar::Minitar.unpack zip, dir
            end

            STDERR.puts "Starting thin server @ #{address}:#{port}"
            Thin::Server.start address, port, self
          end
        end
      end
    end

    class Renderer < View
      def dashboard_path dashboard, page = nil, *tabs
        options = tabs.extract_options!
        page = (page || current_page).name
        tabs = tabs.map { |tab| "/#{tab}" }.join
        window = (options[:window] || self.window).name
        "/dashboards/#{dashboard.name}/#{page}#{tabs}/#{window}.html"
      end

      def window_nav
        html.ul :id => "window-nav", :class => "nav nav-pills fullscreen-hidden" do
          model.windows.each do |window|
            if (self.window.nil? && window.default) or (window.name == self.window.name)
              html.li :class => "active" do
                html.a window.title, :href => dashboard_path(model, current_page, *(tab_path + [{:window => window}]))
              end
            else
              html.li do
                html.a window.title, :href => dashboard_path(model, current_page, *(tab_path + [{:window => window}]))
              end
            end
          end
        end
      end
    end

    class << self
      attr_reader :thread_pool

      def with_thread_pool size
        @thread_pool = Thread::Pool.new size
        yield if block_given?
        @thread_pool.shutdown
      end

      def background &block
        thread_pool.process &block
      end

      def generate! output_stream
        with_tarred_output_stream output_stream do
          with_thread_pool 50 do
            copy_static!
            generate_index!

            Window.each do |window|
              Dashboard.each do |dashboard|
                dashboard.pages.each do |page|
                  tab_tree(page).each do |tab_path|
                    begin
                      generate_page! dashboard, page, tab_path, window
                    rescue Exception => ex
                      STDERR.puts "Problem generating page: #{ex.class} - #{ex.message}"
                    end
                  end
                end
              end
            end
          end
        end
      end

      def with_tarred_output_stream output_stream
        @zip ||= Zlib::GzipWriter.new output_stream
        @tar ||= Archive::Tar::Minitar::Output.new @zip
        @writer ||= @tar.tar
        @mutex ||= Mutex.new
        yield if block_given?
        @tar.close
      end

      def create_file name
        buf = StringIO.new ""

        yield buf if block_given?

        @mutex.synchronize do
          @writer.add_file_simple name.gsub(/^\//, ""), :mode => 0o644, :size => buf.size do |stream|
            stream.write buf.string
          end
        end
      end

      def tab_tree page
        @tab_tree = [[]]
        build_tab_tree page, []
        @tab_tree
      end

      def build_tab_tree page, tab_path = []
        page.children.each do |child|
          if child.is_a? TabSet
            child.tabs.each do |tab|
              extended_tab_path = tab_path + [tab.name]
              @tab_tree << extended_tab_path
              build_tab_tree tab, extended_tab_path
            end
          end
        end
      end

      def layout
        @layout ||= File.open(File.absolute_path("#{__FILE__}/../views/layout.haml")).read
      end

      def index
        @index ||= File.open(File.absolute_path("#{__FILE__}/../views/index.haml")).read
      end

      def generate_page! dashboard, page, tab_path, window
        view = Renderer.new(dashboard, :page => page, :window => window, :tab_path => tab_path)
        filename = view.dashboard_path(dashboard, page, *(tab_path + [:window => window]))
        create_file filename do |file|
          html = haml layout, view, :dashboard => dashboard
          fix_images! html
          file.write html
        end
      end

      def generate_index!
        create_file "/index.html" do |file|
          file.write haml(index)
        end
      end

      def copy_static!
        FileUtils.cd File.expand_path("#{__FILE__}/../public") do
          Dir["**/*"].each do |filename|
            next if File.directory? filename

            create_file filename do |f|
              f.write File.read(filename)
            end
          end
        end
      end

      def haml template, view = Object.new, instance_variables = {}
        haml = Haml::Engine.new(template)

        scope = Class.new do
          include Helper
        end.new
        instance_variables.each do |k, v|
          scope.instance_variable_set :"@#{k}", v
        end

        haml.render scope do
          view.to_html
        end
      end

      def download! src, dest
        background do
          res = RestClient.get(src)
          create_file dest do |f|
            f.write res.body
          end
        end
      end

      def fix_images! html
        html = Nokogiri::HTML(html)
        uuid = UUID.new
        puts "Fix Images "
        html.css("img").each do |img|
          url = img["src"]
          puts "URL #{url}"

          if url !~ /^\/img/
            filename = "/images/#{uuid.generate}"
            puts "Downloading #{filename} #{url}"
            download! url, filename
            img["src"] = filename
          end
        end

        html.css("a.click-enlarge").each do |link|
          url = link["href"]

          if url =~ /^\/img/
            filename = "/images/#{uuid.generate}"
            download! url, filename

            link["href"] = filename
            link.css("img").each do |img|
              img["xxlarge"] = filename
            end
          end
        end

        html.to_s
      end
    end
  end
end
