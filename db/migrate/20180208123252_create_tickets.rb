class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :user, foreign_key: true
      t.references :performance, foreign_key: true
      t.integer :status
      t.integer :access
      t.monetize :price

      t.timestamps
    end
  end
end
