
if node['elk_stack']['install_type'] == 'artifactory'
    installer = "#{node['elk_stack']['openjdk']['package']}-#{node['elk_stack']['openjdk']['version']}-openjdk.rpm"
    remote_file "#{node['elk_stack']['openjdk']['working_directory']}/#{installer}" do
        source "#{node['elk_stack']['artifactoryURL']}#{node['elk_stack']['artifactoryPathOpenJDK']}#{installer}"
        owner 'root'
        group 'root'
        mode  0755
        action :create
    end
end

if node['elk_stack']['install_type'] == 'yumrepository'
    package 'java-1.8.0-openjdk'
elsif node['elk_stack']['install_type'] == 'artifactory'
    installer = "#{node['elk_stack']['openjdk']['package']}-#{node['elk_stack']['openjdk']['version']}-openjdk.rpm"
    bash "Install OpenJDK" do
        code <<-EOC
            sudo yum --nogpgcheck -y localinstall #{node['elk_stack']['openjdk']['working_directory']}/#{installer}
            EOC
    end
end