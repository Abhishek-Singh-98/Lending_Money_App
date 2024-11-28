class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :contact_number
      t.text :address
      t.integer :role
      t.integer :proof_type
      t.string :valid_proof_id
      t.string :password_digest
      t.boolean :fraud, default: false
      t.timestamps
    end
  end
end
