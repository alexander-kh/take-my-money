ActiveAdmin.register User do
  actions :all, except: [:edit]
  
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  
  index do
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end
end
