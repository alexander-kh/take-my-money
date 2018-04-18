class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      
      t.timestamps
    end
    
    change_table :payments do |t|
      t.integer :billing_address_id
      t.integer :shipping_address_id
    end
  end
end
