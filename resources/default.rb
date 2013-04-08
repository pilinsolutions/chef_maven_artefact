#
# Resource to download maven artifacts
#

actions :download

#TODO: join repo attributes and load defaults from somewhere
attribute :maven_repo, :default => 'http://repo1.maven.org/maven2/'
attribute :maven_username, :default => ''
attribute :maven_password, :default => ''

#TODO: join artefact attributes
attribute :maven_group, :kind_of => String, :required => true
attribute :maven_artefact, :kind_of => String, :required => true
attribute :maven_version, :kind_of => String, :required => true

attribute :user, :default => 'root'
attribute :group, :default => 'root'

attribute :destination, :kind_of => String, :name_attribute => true

