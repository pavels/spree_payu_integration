module SpreePayuIntegration

  class Api

    def self.load_transaction(session_id)
      timestamp = Time.now.to_i

      sig_template = [SpreePayuIntegration::Configuration.merchant_pos_id,
                      session_id,
                      timestamp,
                      SpreePayuIntegration::Configuration.signature_key
                     ]

      signature = Digest::MD5.hexdigest(sig_template.join(''))

      uri = URI('https://secure.payu.com/paygw/UTF/Payment/get')
      res = Net::HTTP.post_form(uri, 
          pos_id: SpreePayuIntegration::Configuration.merchant_pos_id,
          session_id: session_id,
          ts: timestamp,
          sig: signature
        )
      return Nokogiri::XML(res.body)
    end
  end
end