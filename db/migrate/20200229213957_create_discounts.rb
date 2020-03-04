class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.string :description
      t.integer :percentage_off
      t.integer :minimum

      t.timestamps
    end
  end
end
