class AddReferenceToTicket < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :payment_reference, :string
  end
end
