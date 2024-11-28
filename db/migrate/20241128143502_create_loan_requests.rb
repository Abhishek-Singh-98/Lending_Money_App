class CreateLoanRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_requests do |t|
      t.float :desired_amount
      t.float :desired_interest
      t.integer :loan_tenure
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.float :interest_payable
      t.float :amount_payable
      t.references :user, null: false, foreign_key: true
      t.string :special_request_id
      t.timestamps
    end
  end
end
