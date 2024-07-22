class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :postal_code, :string, limit:7
    add_column :users, :address, :string
    add_column :users, :bio, :text
  end
end
