#
# Cookbook Name:: maven_artefact
# Recipe:: default
#
# Copyright 2013, PilinSolutions
#
# All rights reserved - Do Not Redistribute
#

package "libxml2-dev" do
  action :install
end

package "libxslt-dev" do
  action :install
end

# Hack for installing chef gem
# TODO: There may be better solution to install chef gems after required OS packages
# TODO: make it as LWRP
mechanize_gem = chef_gem "mechanize" do
    action :nothing
end

nokogiri_gem = chef_gem "nokogiri" do
    action :nothing
end

ruby_block "install_gems_after_required_packages" do
    block do
        mechanize_gem.run_action(:install)
        nokogiri_gem.run_action(:install)
    end
end

