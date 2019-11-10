node['elk_stack']['dependency']['gems'].each do |name, version|
   chef_gem name do
      version version
      source lazy { node['elk_stack']['dependency']['gem_source'] }
      compile_time true
   end
   require name
end

