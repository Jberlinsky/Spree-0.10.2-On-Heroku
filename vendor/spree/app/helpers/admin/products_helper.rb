module Admin::ProductsHelper
  def option_type_select(so)
    select(:new_variant, 
           so.option_type.presentation, 
           so.option_type.option_values.collect {|ov| [ ov.presentation, ov.id ] })
  end

  def pv_tag_id(product_value)
    "product-property-value-#{product_value.id}"
  end

  def exclusive_properties(product, properties)
    product.property_values.each do |pv|
      properties.delete(pv.property)
    end
    properties
  end

end
