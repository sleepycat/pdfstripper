#the path to the gs bin
config_file = "#{Rails.root}/config/ghostscript_config.yml"
GHOSTSCRIPT_BIN = if File.exist? config_file
  YAML.load_file(config_file)[Rails.env]["gs_path"]
else
  "/usr/bin/gs"
end




