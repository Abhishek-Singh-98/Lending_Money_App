class AddConfirmationColumnToLoanRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_requests, :user_confirmed, :boolean, default: nil
  end
end
