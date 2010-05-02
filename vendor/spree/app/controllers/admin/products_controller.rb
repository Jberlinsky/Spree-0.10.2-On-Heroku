class Admin::ProductsController < Admin::BaseController
  resource_controller
  before_filter :load_data, :except => :index

  index.response do |wants|
    wants.html { render :action => :index }
    wants.json { render :json => @collection.to_json(:include => {:variants => {:include => {:option_values => {:include => :option_type}, :images => {}}}, :images => {}, :master => {}})  }
  end

  new_action.response do |wants|
    wants.html {render :action => :new, :layout => false}
  end

  update.before :update_before

  create.before :create_before

  create.response do |wants|
    # go to edit form after creating as new product
    wants.html {redirect_to edit_admin_product_url(Product.find(@product.id)) }
  end

  update.response do |wants|
    # override the default redirect behavior of r_c
    # need to reload Product in case name / permalink has changed
    wants.html {redirect_to edit_admin_product_url(Product.find(@product.id)) }
  end

  # override the destory method to set deleted_at value
  # instead of actually deleting the product.
  def destroy
    @product = Product.find_by_permalink(params[:id])
    @product.deleted_at = Time.now()

    @product.variants.each do |v|
      v.deleted_at = Time.now()
      v.save
    end

    if @product.save
      flash[:notice] = I18n.t("notice_messages.product_deleted")
    else
      flash[:notice] = I18n.t("notice_messages.product_not_deleted")
    end

    respond_to do |format|
      format.html { redirect_to collection_url }
      format.js  { render_js_for_destroy }
    end
  end

  def clone
    load_object
    @new = @product.duplicate

    if @new.save
      flash[:notice] = I18n.t("notice_messages.product_cloned")
    else
      flash[:notice] = I18n.t("notice_messages.product_not_cloned")
    end

    redirect_to edit_admin_product_url(@new)
  end

  private
    def load_data
      @tax_categories = TaxCategory.find(:all, :order=>"name")
      @shipping_categories = ShippingCategory.find(:all, :order=>"name")
    end

    def collection
      unless request.xhr?
        base_scope = end_of_association_chain

        # Note: the SL scopes are on/off switches, so we need to select "not_deleted" explicitly if the switch is off
        # QUERY - better as named scope or as SL scope?
        if params[:search].nil? || params[:search][:deleted_at_not_null].blank?
          base_scope = base_scope.not_deleted
        end

        @search = base_scope.group_by_products_id.searchlogic(params[:search])
        @search.order ||= "ascend_by_name"

        @collection = @search.paginate(:include  => {:variants => [:images, :option_values]},
                                       :per_page => Spree::Config[:admin_products_per_page],
                                       :page     => params[:page])
      else
        @collection = Product.find( :all,
                                    :conditions => ["name like ?", "%#{params[:q]}%"],
                                    :include =>  [{:variants => [:images,  {:option_values => :option_type}]}, :master, :images])

        @collection.concat Product.find( :all,
                                    :conditions => ["variants.sku like ?", "%#{params[:q]}%"],
                                    :include =>  [{:variants => [:images,  {:option_values => :option_type}]}, :master, :images])

        @collection.uniq!
      end

    end

    # set the default tax_category if applicable
    def create_before
      return unless Spree::Config[:default_tax_category]
      @product.tax_category ||= TaxCategory.find_by_name Spree::Config[:default_tax_category]
    end

    def update_before
      # note: we only reset the product properties if we're receiving a post from the form on that tab
      return unless params[:clear_product_properties]
      params[:product] ||= {}
      params[:product][:product_property_attributes] ||= {} if params[:product][:product_property_attributes].nil?
    end

end
