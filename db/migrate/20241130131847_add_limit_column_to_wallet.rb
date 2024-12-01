class AddLimitColumnToWallet < ActiveRecord::Migration[7.0]
  def change
    add_column :wallets, :max_limit, :float
  end
end
