class HomeController < ApplicationController
  before_action :account_required!, only: [:account_details]

  def index
    @products = Product.all
    @order = current_order(false)
  end

  def account_details
    @account_activities = @current_account.account_activities
  end

  def publish_number
    ActionCable.server.broadcast 'rfid_read',
                                 card: params[:card]
    render text: 'ok'
  end

  def read
    # r = ""
    # `ssh pi@192.168.1.83 "sudo ./kill_reader.sh"`
    # begin
    #   status = Timeout::timeout(10) {
    #     r = `ssh pi@192.168.1.83 "sudo python read.py > /dev/null &"`
    #   }
    # rescue
    # end
    # `ssh pi@192.168.1.83 "sudo ./kill_reader.sh"`
    # @response = r.gsub(/[^\d]/, '')

    `sudo readRfid.sh`
  end

  def login
    unless request.get?
      if params[:card].present?
        account = Account.where(card: params[:card]).first
        session[:account_id] = account.id
      end
      redirect_to account_details_home_path
    end
  end

  def logout
    session.delete :account_id
    flash[:success] = "Çıkış yapıldı"
    redirect_to root_path
  end

end