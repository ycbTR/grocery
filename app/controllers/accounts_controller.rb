class AccountsController < AdminController
  before_action :authorize_only_admin!
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    params[:q] ||= {}
    params[:q][:s] ||= "id desc"
    params[:q][:deleted_at_null] ||= "1"
    @q = Account.ransack(params[:q])
    if request.format.xls?
      filename = "Hesaplar_#{I18n.localize(Time.current, format: :custom)}.xls"
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
      @accounts = @q.result(distinct: true)
    else
      @accounts = @q.result(distinct: true).page(params[:page])
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    redirect_to account_details_home_path(id: @account) and return
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        next_path = if params[:commit] == "Kaydet ve Yeni Ekle"
                      new_account_path
                    else
                      accounts_path
                    end
        format.html { redirect_to next_path, notice: 'Hesap oluşturuldu' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: 'Hesap güncellendi' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:name, :card, :balance, :credit_limit, :admin, :cashier, :second_admin)
  end
end
