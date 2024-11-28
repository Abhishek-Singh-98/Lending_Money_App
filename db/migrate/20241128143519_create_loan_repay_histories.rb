class CreateLoanRepayHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_repay_histories do |t|
      t.references :user
      t.references :loan_request
      t.datetime :payment_date
      t.float :amount_paid
      t.timestamps
    end
  end
end
