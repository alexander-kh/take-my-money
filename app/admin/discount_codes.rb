ActiveAdmin.register DiscountCode do
  permit_params :code, :percentage
  
  filter :code
  filter :percentage
  filter :description
  
  index do
    selectable_column
    id_column
    column :code
    column :percentage
    column :description
    actions
  end
end
