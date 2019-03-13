json.extract! account_activity, :id, :order_id, :amount, :account_id, :created_at, :updated_at
json.url account_activity_url(account_activity, format: :json)
