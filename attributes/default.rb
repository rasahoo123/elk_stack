default['elk_stack'] = {
   'repos' => %w[elasticsearch logstash kibana],
   'install_type' => 'yumrepository',
   'yumrepos' => {
      'baseurl' => "https://artifacts.elastic.co/packages/",
      'gpgkey'  => "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
   },
   'artifactory' => {
      'artifactoryURL' => 'http://piab-artifactory.piab.local:8081/artifactory/',
      'artifactoryPath' => 'General-Artifacts/elk',
      'artifacgtoryPathOpenJDK' => 'General-Artifacts/'
   },
   'elasticsearch' => {
      'package' => 'elasticsearch',
      'version' => '7.4.1',
      'working_directory' => '/tmp',
      'data_dir' => '/var/lib/elasticsearch',
      'log_dir'  => '/var/log/elasticsearch'
   },
   'logstash' => {
      'package' => 'logstash',
      'version' => '7.4.1',
      'working_directory' => '/tmp',
      'conf_files' => ['02-beats-input.conf', '10-syslog-filter.conf', '30-elasticsearch-output.conf'],
      'conf_path'  => '/etc/logstash/conf.d/'
   },
   'kibana' => {
      'package' => 'kibana',
      'version' => '7.4.1',
      'working_directory' => '/tmp'
   },
   'openjdk' => {
      'package' => 'java',
      'version' => '1.8.0',
      'working_directory' => '/tmp'
   }
}
