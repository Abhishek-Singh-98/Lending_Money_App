class CreateLoanRequestReadjustments < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_request_readjustments do |t|
      t.references :loan_request
      t.float :previous_amount
      t.float :readjusted_amount
      t.float :previous_interest
      t.float :readjusted_interest
      t.integer :previous_tenure
      t.integer :readjusted_tenure
      t.string :readjusted_by
      t.timestamps
    end
  end
end
