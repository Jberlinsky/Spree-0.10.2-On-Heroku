class Gateway::AuthorizeNetCim < Gateway
	preference :login, :string
	preference :password, :string
  preference :test_mode, :boolean, :default => false

  ActiveMerchant::Billing::Response.class_eval do
    attr_writer :authorization
  end

  def provider_class
    self.class
  end	

  def authorize(amount, creditcard, gateway_options)
    create_transaction(amount, creditcard, :auth_only)
  end
  
  def purchase(amount, creditcard, gateway_options)
    create_transaction(amount, creditcard, :auth_capture)
  end

  def capture(authorization, creditcard, gateway_options)
    create_transaction((authorization.amount * 100).round, creditcard, :prior_auth_capture, :trans_id => authorization.response_code)
  end
  
  def credit(amount, creditcard, response_code, gateway_options)
    create_transaction(amount, creditcard, :refund, :trans_id => response_code)
  end
  
  def void(response_code, creditcard, gateway_options)
    create_transaction(nil, creditcard, :void, :trans_id => response_code)
  end
  
  def payment_profiles_supported?
	  true
  end

  # Create a new CIM customer profile ready to accept a payment
  def create_profile(creditcard, gateway_options)
    if creditcard.gateway_customer_profile_id.nil?
      profile_hash = create_customer_profile(creditcard, gateway_options)
      creditcard.update_attributes(:gateway_customer_profile_id => profile_hash[:customer_profile_id], :gateway_payment_profile_id => profile_hash[:customer_payment_profile_id])
    end
  end


  private

    # Create a transaction on a creditcard
    # Set up a CIM profile for the card if one doesn't exist
    # Valid transaction_types are :auth_only, :capture_only and :auth_capture
    def create_transaction(amount, creditcard, transaction_type, options = {})
      #create_profile(creditcard, creditcard.gateway_options)
      creditcard.save
      if amount
        amount = "%.2f" % (amount/100.0) # This gateway requires formated decimal, not cents
      end
      transaction_options = {
        :type => transaction_type, 
        :amount => amount,
        :customer_profile_id => creditcard.gateway_customer_profile_id,
        :customer_payment_profile_id => creditcard.gateway_payment_profile_id,
      }.update(options)
      t = cim_gateway.create_customer_profile_transaction(:transaction => transaction_options)
      logger.debug("\nAuthorize Net CIM Transaction")
      logger.debug("  transaction_options: #{transaction_options.inspect}")
      logger.debug("  response: #{t.inspect}\n")
      t
    end
  
    # Create a new CIM customer profile ready to accept a payment
    def create_customer_profile(creditcard, gateway_options)
      options = options_for_create_customer_profile(creditcard, gateway_options)
      response = cim_gateway.create_customer_profile(options)
      if response.success?
        { :customer_profile_id => response.params["customer_profile_id"], 
          :customer_payment_profile_id => response.params["customer_payment_profile_id_list"].values.first }
      else
        creditcard.gateway_error(response)
      end
    end

    def options_for_create_customer_profile(creditcard, gateway_options)
        {:profile => { :merchant_customer_id => "#{Time.now.to_f}",
          #:ship_to_list => generate_address_hash(creditcard.checkout.ship_address),
          :payment_profiles => {
            #:bill_to => generate_address_hash(creditcard.checkout.bill_address),
            :payment => { :credit_card => creditcard}
          }
        }}
    end

    # As in PaymentGateway but with separate name fields
    def generate_address_hash(address)
      return {} if address.nil?
      {:first_name => address.firstname, :last_name => address.lastname, :address1 => address.address1, :address2 => address.address2, :city => address.city,
       :state => address.state_text, :zip => address.zipcode, :country => address.country.iso, :phone => address.phone}
    end

    def cim_gateway
      ActiveMerchant::Billing::Base.gateway_mode = preferred_server.to_sym
      gateway_options = options
  		ActiveMerchant::Billing::AuthorizeNetCimGateway.new(gateway_options)
    end 
    
end
