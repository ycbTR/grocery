json.extract! account, :id, :name, :card, :balance, :created_at, :updated_at
json.url account_url(account, format: :json)
