SAMPLE_POS_ID = '145227'
SAMPLE_SIGNATURE_KEY = '13a980d4f851f3d9a1cfc792fb1f5e50'
SAMPLE_POS_AUTH_KEY = ''

SpreePayuIntegration::Configuration.configure do |config|
  config.merchant_pos_id  = SAMPLE_POS_ID
  config.signature_key    = SAMPLE_SIGNATURE_KEY
  config.pos_auth_key = SAMPLE_POS_AUTH_KEY
end
