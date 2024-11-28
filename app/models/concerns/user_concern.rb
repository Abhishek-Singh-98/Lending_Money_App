module UserConcern
  extend ActiveSupport::Concern

  included do

    after_commit :create_wallet
  end

  def create_wallet
    if Admin?
      Wallet.create(user_id: self.id, amount: 10_00_000.to_f)
    else
      Wallet.create(user_id: self.id, amount: 0.0)
    end
  end
end