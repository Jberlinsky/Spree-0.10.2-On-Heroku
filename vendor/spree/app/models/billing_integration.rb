class BillingIntegration < PaymentMethod

  validates_presence_of :name, :type

  preference :server, :string, :default => 'test'
  preference :test_mode, :boolean, :default => true

  def provider
    integration_options = options
    ActiveMerchant::Billing::Base.integration_mode = integration_options[:server]
    integration_options = options
    integration_options[:test] = true if integration_options[:test_mode]
    @provider ||= provider_class.new(integration_options)
  end

  def options
    options_hash = {}
    self.preferences.each do |key,value|
      options_hash[key.to_sym] = value
    end
    options_hash
  end
end
