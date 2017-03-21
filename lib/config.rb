require 'yaml'
module Config
  def config
    @settings ||= YAML.load(File.read(config_file))
  end

  private

  def config_file
    "#{File.dirname(__FILE__)}/../config/config.yml"
  end
end