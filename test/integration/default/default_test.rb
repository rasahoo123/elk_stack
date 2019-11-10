# InSpec test for recipe elk_stack::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe package('elasticsearch-7.4.1-1') do
  it { should be_installed}
end

describe package('logstash-7.4.1-1') do
  it { should be_installed}
end

describe package('kibana-7.4.1-1') do
  it { should be_installed}
end

describe service('elasticsearch') do
  it { should be_enabled}
  it { should be_installed}
  it { should be_running}
end

describe service('logstash') do
  it { should be_enabled}
  it { should be_installed}
  it { should be_running}
end

describe service('kibana') do
  it { should be_enabled}
  it { should be_installed}
  it { should be_running}
end

describe port(9200) do
  it { should be_listening }
end

describe port(5601) do
  it { should be_listening }
end
