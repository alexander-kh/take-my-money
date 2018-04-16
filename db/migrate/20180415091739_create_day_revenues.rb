class CreateDayRevenues < ActiveRecord::Migration[5.1]
  def change
    create_table :day_revenues do |t|
      t.date :day
      t.integer :ticket_count
      t.monetize :price
      t.monetize :discounts

      t.timestamps
    end
  end
end
