class AccountActivitiesController < AdminController
  before_action :set_account_activity, only: [:show, :edit, :update, :destroy]

  # GET /account_activities
  # GET /account_activities.json
  def index
    @account_activities = AccountActivity.all
  end

  # GET /account_activities/1
  # GET /account_activities/1.json
  def show
  end

  # GET /account_activities/new
  def new
    @account_activity = AccountActivity.new
  end

  # GET /account_activities/1/edit
  def edit
  end

  # POST /account_activities
  # POST /account_activities.json
  def create
    @account_activity = AccountActivity.new(account_activity_params)
    @account_activity.source = Account.first
    respond_to do |format|
      if @account_activity.save
        format.html { redirect_to @account_activity, notice: 'Account activity was successfully created.' }
        format.json { render :show, status: :created, location: @account_activity }
      else
        format.html { render :new }
        format.json { render json: @account_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_activities/1
  # PATCH/PUT /account_activities/1.json
  def update
    respond_to do |format|
      if @account_activity.update(account_activity_params)
        format.html { redirect_to @account_activity, notice: 'Account activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_activity }
      else
        format.html { render :edit }
        format.json { render json: @account_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_activities/1
  # DELETE /account_activities/1.json
  def destroy
    @account_activity.destroy
    respond_to do |format|
      format.html { redirect_to account_activities_url, notice: 'Account activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_activity
      @account_activity = AccountActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_activity_params
      params.require(:account_activity).permit(:order_id, :amount, :account_id)
    end
end
