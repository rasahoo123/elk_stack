#
# Cookbook:: elk_stack
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

include_recipe 'elk_stack::includes'
include_recipe 'elk_stack::resources'
include_recipe 'elk_stack::prerequisites'
include_recipe 'elk_stack::elk_installation'
