require "open3"

Puppet::Functions.create_function(:zulipconf) do
  def zulipconf(section, key, default)
    doer_conf_path = Facter.value("doer_conf_path")
    output, _stderr, status = Open3.capture3("/usr/bin/crudini", "--get", "--", doer_conf_path, section, key)
    if status.success?
      if [true, false].include? default
        # If the default is a bool, coerce into a bool.  This list is also
        # maintained in scripts/lib/doer_tools.py
        ["1", "y", "t", "true", "yes", "enable", "enabled"].include? output.strip.downcase
      else
        output.strip
      end
    else
      default
    end
  end
end
