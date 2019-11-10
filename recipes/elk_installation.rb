#node['elk_stack']['repos'].each do |file_name|
#    puts "*********************"
#    puts file_name
#    puts "#{node['elk_stack'][file_name]['version'].to_i}" 
#    puts "#{node['elk_stack'][file_name]['package']}"
#    puts "*********************"
#end

group 'elasticsearch' do
    gid '1234'
    system true
    action :create
end

user 'elasticsearch' do
    comment 'Elastcsearch User'
    shell '/bin/bash'
    uid '1234'
    gid '1234'
    manage_home false
    system true
    action :create
end

node['elk_stack']['repos'].each do |file_name|
    if node['elk_stack']['install_type'] == 'yumrepository'
        yum_repository file_name.to_s do
            description file_name.to_s + ' ' + "#{node['elk_stack'][file_name]['version'].to_i}.x yum repository"
            baseurl "#{node['elk_stack']['yumrepos']['baseurl']}#{node['elk_stack'][file_name]['version'].to_i}.x/yum"
            gpgkey  "#{node['elk_stack']['yumrepos']['gpgkey']}" 
            action :create
        end
    elsif node['elk_stack']['install_type'] == 'artifactory'
        installer = "#{node['elk_stack'][file_name]['package']}-#{node['elk_stack'][file_name]['version']}-x86_64.rpm"
        remote_file "#{node['elk_stack'][file_name]['working_directory']}/#{installer}" do
            source "#{node['elk_stack']['artifactoryURL']}#{node['elk_stack']['artifactoryPath']}#{installer}"
            owner 'root'
            group 'root'
            mode  0755
            action :create
        end
    end
end

# Create elasticsearch directories on ESB
directory node['elk_stack']['elasticsearch']['data_dir'] do
    owner 'elasticsearch'
    group 'elasticsearch'
    mode '0777'
    recursive true
    action :create
end 

directory node['elk_stack']['elasticsearch']['log_dir'] do
    owner 'elasticsearch'
    group 'elasticsearch'
    mode '0777'
    recursive true
    action :create
end 

node['elk_stack']['repos'].each do |file_name|
    if node['elk_stack']['install_type'] == 'yumrepository'
        package "#{file_name}-#{node['elk_stack'][file_name]['version']}-1"
    elsif node['elk_stack']['install_type'] == 'artifactory'
        installer = "#{node['elk_stack'][file_name]['package']}-#{node['elk_stack'][file_name]['version']}-x86_64.rpm"
        bash "Install #{file_name}" do
            code <<-EOC
              sudo yum --nogpgcheck -y localinstall #{node['elk_stack'][file_name]['working_directory']}/#{installer}
              EOC
        end
    end
end

ipaddress = node['ipaddress']
ipaddress = 'localhost' if ipaddress.nil? || ipaddress.empty?

# Change the elasticsearch.yml
template '/etc/elasticsearch/elasticsearch.yml' do
    source 'elasticsearch.erb'
    owner 'elasticsearch'
    group 'elasticsearch'
    mode '0644'
    variables(host_ip: ipaddress.to_s, es_data_dir: node['elk_stack']['elasticsearch']['data_dir'],es_log_dir: node['elk_stack']['elasticsearch']['log_dir'])
end

# Change the kibana.yml
template '/etc/kibana/kibana.yml' do
    source 'kibana.erb'
    owner 'root'
    group 'root'
    variables(host_ip: ipaddress.to_s)
end

# Add the logstash configuration files
node['elk_stack']['logstash']['conf_files'].each do |file_name|
    cookbook_file node['elk_stack']['logstash']['conf_path'] + file_name.to_s do
        source file_name.to_s
        owner 'root'
        group 'root'
        mode '0644'
        action :create
    end
end

# Add the Cert and private key
cookbook_file '/etc/pki/tls/certs/logstash-forwarder.crt' do
    source 'star_piab_local.crt'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

cookbook_file '/etc/pki/tls/private/logstash-forwarder.key' do
    source 'star_piab_local.key'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

# Enable and Start the Service
node['elk_stack']['repos'].each do |file_name|
    service file_name do
        action %i[enable restart]
    end
end

