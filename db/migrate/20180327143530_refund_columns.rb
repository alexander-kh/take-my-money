class RefundColumns < ActiveRecord::Migration[5.1]
  def change
    change_table :payments do |t|
      t.references :original_payment, index: true
      t.references :administrator, index: true
    end
    
    change_table :payment_line_items do |t|
      t.references :original_line_item, index: true
      t.references :administrator, index: true
      t.integer :refund_status, default: 0
    end
  end
end
