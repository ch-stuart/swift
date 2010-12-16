env_config = YAML.load_file("#{Rails.root}/config/app.yml")[Rails.env]
app_config = YAML.load_file("#{Rails.root}/config/app.yml")['application']
APP_CONFIG = env_config.merge(app_config)
