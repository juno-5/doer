require "open3"

Facter.add(:doer_version) do
  setcode do
    Dir.chdir("/home/zulip/deployments/current") do
      output, stderr, status = Open3.capture3("python3", "-c", "import version; print(version.DOER_VERSION_WITHOUT_COMMIT)")
      if not status.success?
        Facter.debug("doer_version error: #{stderr}")
        nil
      else
        output.strip
      end
    end
  end
end
