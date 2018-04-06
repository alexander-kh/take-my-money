ActiveAdmin.register Subscription do
  filter :plan_id
  filter :start_date
  filter :end_date
  filter :status
  filter :payment_method
  filter :created_at
  
  index do
    selectable_column
    id_column
    column :user_id
    column :plan
    column :start_date
    column :end_date
    column :status
    column :payment_method
    column :remote_id
    column :created_at
    actions
  end
  
  show do
    attributes_table do
      row :user_id
      row :plan
      row :start_date
      row :end_date
      row :status
      row :payment_method
      row :remote_id
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)
      f.input :user_id
      f.input :plan
      f.input :start_date, as: :string
      f.input :end_date, as: :string
      f.input :status
    end
    f.actions
  end
end
