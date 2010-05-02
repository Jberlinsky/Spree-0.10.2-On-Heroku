require 'test_helper'

class Admin::ShipmentsControllerTest < ActionController::TestCase
  setup do
    UserSession.create(Factory(:admin_user))
  end

  context "on GET to :edit" do
    setup do
      create_complete_order
      @order.complete!
      get :edit, :order_id => @order.id, :id => @order.shipment.id
    end
    should_respond_with :success
    should_render_template "edit"
  end
  
  context "changing shipping method" do 
    setup do
      @new_shipping_method = Factory(:shipping_method)
      c = @new_shipping_method.calculator
      c.preferred_amount = 5.0
      c.save!
      
      create_complete_order
      @order.complete!
    end
  
    context "without recalculate checked" do
      setup do
        put :update, :order_id => @order.id, :id => @order.shipment.id, :shipment => {:shipping_method_id => @new_shipping_method.id}
        @order.reload
      end
      should_respond_with :redirect
      should "not change ship_total" do
        assert_equal 10.0, @order.ship_total
      end
    end

    context "with recalculate checked" do
      setup do
        put :update, :order_id => @order.id, :id => @order.shipment.id, 
          :shipment => {:shipping_method_id => @new_shipping_method.id}, 
          :recalculate => '1'
        @order.reload
      end
      should_change("@order.ship_total", :to => 5) { @order.ship_total }
    end    
    
    context "trying to update shipment that's already shipped" do
      setup do
        @order.shipment.update_attribute(:state, 'shipped')
        put :update, :order_id => @order.id, :id => @order.shipment.id, 
          :shipment => {:shipping_method_id => @new_shipping_method.id}
        @order.reload
      end
      should_redirect_to_authorization_failure
    end
  
  end
end
