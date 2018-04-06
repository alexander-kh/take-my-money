ActiveAdmin.register Ticket do
  permit_params :performance_id, :status, :access, :price_cents, :price_currency
  
  filter :performance
  filter :event
  filter :status
  filter :access
  
  index do
    selectable_column
    id_column
    column :user_id
    column :status
    column :access
    column :price
    column :payment_reference
    actions
  end
  
  show do
    attributes_table do
      row :user_id
      row :performance
      row :status
      row :access
      row :price_cents
      row :price_currency
      row :created_at
      row :updated_at
      row :payment_reference
    end
    active_admin_comments
  end
  
  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :performance
      f.input :status
      f.input :access
      f.input :price_cents
      f.input :price_currency
    end
    f.actions
  end
end
