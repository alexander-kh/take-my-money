class AddAuthyToUser < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :authy_id
    end
  end
end
