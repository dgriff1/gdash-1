INSTANCES = 3
RACKUP = File.expand_path(File.join(File.dirname(__FILE__), "..", "config.ru"))

INSTANCES.times do |instance|
  log_file = File.expand_path(File.join(File.dirname(__FILE__), "..", "log", "gdash.#{instance}.log"))

  God.watch do |watch|
    watch.name = "GDash #{instance}"
    watch.group = "gdash"
    watch.start = "bundle exec thin --address 127.0.0.1 --port #{3000 + instance} --rackup #{RACKUP} --log #{log_file} --environment production start"
    watch.restart = "bundle exec thin --address 127.0.0.1 --port #{3000 + instance} --rackup #{RACKUP} --log #{log_file} --environment production restart"
    watch.stop = "bundle exec thin --address 127.0.0.1 --port #{3000 + instance} --rackup #{RACKUP} --log #{log_file} --environment production stop"
    watch.behavior :clean_pid_file
    watch.keepalive
    watch.log = log_file
  end
end
