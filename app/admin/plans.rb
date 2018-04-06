ActiveAdmin.register Plan do
  filter :nickname
  filter :ticket_category
  filter :status
  
  index do
    selectable_column
    id_column
    column :remote_id
    column :nickname
    column :price
    column :interval
    column :tickets_allowed
    column :ticket_category
    column :status
    actions
  end
end
