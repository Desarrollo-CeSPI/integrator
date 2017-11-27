Integrator.setup do |config|
  # configure the url for UNLP Integrator APIv2
  config.url = ''
  
  # configure your token for accessing UNLP Integrator APIv2
  config.token = ''

  # config.expires_in = 1.hour

  # configure your API version
  config.version = 'v1'

  # configure your verion data location (HEADER | FIRST_URL_PARAMETER)
  config.version_data_location = 'HEADER' 
end
