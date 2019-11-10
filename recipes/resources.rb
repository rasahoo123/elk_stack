ruby_block 'wait_for_elk_stack' do
  block do
    sleep(60)
  end
  action :nothing
end
