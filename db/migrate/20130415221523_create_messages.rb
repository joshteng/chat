class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.string :user_id
      t.string :ip_address
      t.timestamps
    end
    add_index :messages, :user_id
  end
end
