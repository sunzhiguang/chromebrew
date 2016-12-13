require 'package_helpers'

class Package
  property :version, :binary_url, :binary_sha1, :source_url, :source_sha1, :is_fake
  
  class << self
    attr_reader :dependencies, :is_fake
    attr_accessor :name
  end
  def self.depends_on (dependency = nil)
    @dependencies = [] unless @dependencies
    if dependency
      @dependencies << dependency
    end
    @dependencies
  end
  
  def self.is_fake
    @is_fake = true
  end
  
  def self.is_fake?
    @is_fake
  end

  def self.build
    
  end

  def self.system(*args)
    # strip -m32 option and convert lib32 to lib for the case of ARM to avoid SHORTARCH flood
    if ARCH == "armv7l"
      args = args.map {|s| s.gsub("-m32", "")}
      args = args.map {|s| s.gsub("lib32", "lib")}
    end
    Kernel.system(*args)
    exitstatus = $?.exitstatus
    raise InstallError.new("`#{args.join(" ")}` exited with #{exitstatus}") unless exitstatus == 0
  end
end