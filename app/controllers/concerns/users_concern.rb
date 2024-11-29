module UsersConcern
  extend ActiveSupport::Concern
  
  def update_status_according_to_role
    if @user.Admin?
      @loan_request.update(status: 'waiting_for_adjustment_acceptance')
    else
      @loan_request.update(status: 'readjustment_requested')
    end
  end
end