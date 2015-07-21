require "puppet/provider/package"

Puppet::Type.type(:package).provide(:julia, :parent => Puppet::Provider::Package) do
  desc "Julia packages via `Pkg.add`."

  has_feature :installable, :uninstallable, :versionable, :upgradeable

  commands :julia => "julia"

  def self.parse(line)
    line.tr('[]','').split(",").collect{|x|
        if x =~ /\"(\S+)\"=>v\"(\d+\.\d+\.\d+)/
            new({:ensure => $2, :name => $1, :provider => :julia})
        else
           nil
       end
    }.compact
  end

  def self.instances
    command = [command(:julia), "-E", "Pkg.installed()"]

    begin
      output = execute(command, command_opts)
      parse(output)
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "Could not list Julia packages: #{e}"
    end
  end

  def query
    self.class.instances.each do |pkg|
      return pkg.properties if @resource.name == pkg.name
    end
    nil
  end

  def latest
    command = [command(:julia), "-E", "Pkg.available(\"#{@resource[:name]}\")"]
    output = execute(command, self.class.command_opts)
    output = output.tr('[]','').split(",").collect{|x|
        if x =~ /v\"(\d+\.\d+\.\d+)/
            $1
        else
           nil
       end
    }
    if output.last
      output.last
    else
      @property_hash[:ensure]
    end
  end

  def install
    command = [command(:julia), "-E"]
    should = @resource.should(:ensure)
    if [:latest, :installed, :present].include?(should)
      command << "Pkg.add(\"#{@resource[:name]}\")"
    else
      command << "Pkg.add(\"#{@resource[:name]}\",v\"#{should}\")"
    end
    execute(command, self.class.command_opts)
  end

  def update
    self.install
  end

  def uninstall
    command = [command(:julia), "-E", "Pkg.rm(\"#{@resource[:name]}\")"]
    execute(command, self.class.command_opts)
  end

  def self.default_user
    Facter.value(:boxen_user) || Facter.value(:id) || "root"
  end

  def self.home
    Facter.value(:homebrew_root)
  end

  def self.homedir_prefix
    case Facter[:osfamily].value
    when "Darwin" then "Users"
    when "Linux" then "home"
    else
      raise "unsupported"
    end
  end

  def self.command_opts
    @command_opts ||= {
      :combine            => true,
      :custom_environment => {
        "HOME"            => "/#{homedir_prefix}/#{default_user}",
        "PATH"            => "#{home}/bin:/usr/bin:/usr/sbin:/bin:/sbin",
      },
      :failonfail         => true,
      :uid                => default_user
    }
  end
end
