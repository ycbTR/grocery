class Product < ApplicationRecord
  has_one_attached :image


  def destroy
    self.touch :deleted_at
  end
end
