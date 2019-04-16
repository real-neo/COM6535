Airbrake.configure do |config|
  config.api_key = '6623cb18089aba6e402ea0b026b79583'
  config.host    = 'errbit.genesys.shefcompsci.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end
