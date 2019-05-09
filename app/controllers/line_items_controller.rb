class LineItemsController < AdminController
  skip_before_action :authorize_admin!, only: [:update]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :cancel]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = LineItem.new(line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item, notice: 'Line item was successfully created.' }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      @order = current_order
      if @line_item.update(line_item_params)
        @order.reload
        if @line_item.product.count_on_hand <= @order.line_items.where(product_id: @line_item.product_id).sum(:quantity)
          @li = @line_item
        else
          @product_ids_to_show = [@line_item.product_id]
        end
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.js {  }
      else
        format.js {  }
      end
    end
  end

  def cancel
    @line_item
    @line_item.cancel!
    flash[:success] = "İptal edildi"
    redirect_to order_path(@line_item.order_id, return_to: orders_path)
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    # TODO Add state to line items - cancel - order cancel
    @line_item.destroy
    @order.destroy if @order.reload.line_items.blank?
    respond_to do |format|
      format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:order_id, :quantity, :price, :total, :product_id)
    end
end
