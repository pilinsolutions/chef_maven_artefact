#
# Provider for downloading maven artifact
#

action :download do
    require 'nokogiri'
    require 'mechanize'
    require 'fileutils'

    agent = Mechanize.new
    agent.add_auth(new_resource.maven_repo, new_resource.maven_username, new_resource.maven_password)

    groupPath = new_resource.maven_group.gsub(/\./,'/')

    artefact_version = new_resource.maven_version
    version = new_resource.maven_version
    case new_resource.maven_version
    when 'latest'
        body = agent.get("#{new_resource.maven_repo}/#{groupPath}/#{new_resource.maven_artefact}/maven-metadata.xml")
        metadata = Nokogiri::XML(body.body)
        latest_version = metadata.xpath("/metadata/versioning/latest/text()").to_s
        body = agent.get("#{new_resource.maven_repo}/#{groupPath}/#{new_resource.maven_artefact}/#{latest_version}/maven-metadata.xml")
        metadata = Nokogiri::XML(body.body)
        artefact_version = metadata.xpath(
            "/metadata/versioning/snapshotVersions/snapshotVersion[extension/text()='war']/value/text()").to_s()
            version = latest_version
    when 'release'
        body = agent.get("#{new_resource.maven_repo}/#{groupPath}/#{new_resource.maven_artefact}/maven-metadata.xml")
        metadata = Nokogiri::XML(body.body)
        release_vesrion = metadata.xpath("/metadata/versioning/release/text()").to_s
        artefact_version = release_version
        version = release_vesrion
    end

    artefact_file_name = "#{new_resource.maven_artefact}-#{artefact_version}.war"
    tmp_file_name = "/tmp/#{artefact_file_name}"
    if not ::File.exists?(tmp_file_name)
        # TODO: Check signatures
        uri = "#{new_resource.maven_repo}/#{groupPath}/#{new_resource.maven_artefact}/#{version}/#{new_resource.maven_artefact}-#{artefact_version}.war"
        agent.download(uri, tmp_file_name)

        FileUtils.chown(new_resource.user, new_resource.group, tmp_file_name)
        FileUtils.cp(tmp_file_name, new_resource.destination, :preserve => true)
        # TODO: Delete old file / files (clean up)
    end
end

