module Admin::InventorySettingsHelper
  def show_not(true_or_false)
    true_or_false ? '' : 'not'
  end
end
