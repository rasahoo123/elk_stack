
if node['elk_stack']['install_type'] == 'artifactory'
    installer = "#{node['elk_stack']['openjdk']['package']}-#{node['elk_stack']['openjdk']['version']}-openjdk.rpm"
    remote_file "#{node['elk_stack']['openjdk']['working_directory']}/#{installer}" do
        source "#{node['elk_stack']['artifactoryURL']}#{node['elk_stack']['artifactoryPathOpenJDK']}#{installer}"
        owner 'root'
        group 'root'
        mode  0755
        action :create
    end
elsif node['elk_stack']['install_type'] == 'localserver'
    installer = "#{node['elk_stack']['openjdk']['package']}-#{node['elk_stack']['openjdk']['version']}-openjdk.rpm"
    remote_file "#{node['elk_stack']['openjdk']['working_directory']}/#{installer}" do
        source "#{node['elk_stack']['localserver']['filepath']}/#{installer}"
        owner 'root'
        group 'root'
        mode  0755
        action :create
    end
else
    Chef::Log.error("Invalid Installation Source: #{node['elk_stack']['install_type']}")
end

if node['elk_stack']['install_type'] == 'yumrepository' || node['elk_stack']['install_type'] == 'localserver'
    package 'java-1.8.0-openjdk'
elsif node['elk_stack']['install_type'] == 'artifactory' 
    installer = "#{node['elk_stack']['openjdk']['package']}-#{node['elk_stack']['openjdk']['version']}-openjdk.rpm"
    bash "Install OpenJDK" do
        code <<-EOC
            sudo yum --nogpgcheck -y localinstall #{node['elk_stack']['openjdk']['working_directory']}/#{installer}
            EOC
    end
end

