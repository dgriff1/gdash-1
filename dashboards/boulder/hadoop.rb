KAFKA_PROD_TOPICS = ["prod-lbapi", "prod-beacon", "prod-server-start", "prod-server-end", "trial-server-start", "trial-server-end"]
KAFKA_TEST_TOPICS = ["test-beacon", "dev-server-start", "dev-server-end", "test-server-start", "test-server-end", "loadtest-server-start", "loadtest-server-end"]
KAFKA_TOPICS = KAFKA_PROD_TOPICS + KAFKA_TEST_TOPICS

require 'boulder/hadoop/development'
require 'boulder/hadoop/hadoop'
require 'boulder/hadoop/kafka'
require 'boulder/hadoop/zookeeper'

GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :hadoop do |hadoop|
    hadoop.title = "Hadoop Clusters"
    hadoop.description = "Hadoop and Friends in Boulder"
  end
end