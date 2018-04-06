ActiveAdmin.register PaymentLineItem do
  actions :all, except: [:edit]
  
  filter :buyable_type
  filter :price_cents
  filter :refund_status
  filter :administrator_id
  filter :created_at
  
  index do
    selectable_column
    id_column
    column :buyable_type
    column :price
    column :created_at
    actions
  end
  
  action_item :refund, only: :show do
    link_to("Refund Payment",
      refunds_path(id: payment_line_item.id, type: PaymentLineItem),
      method: "POST",
      class: "button",
      data: {confirm: "Are you sure you want to refund this payment?"})
  end
end
