json.array!(@alerts) do |alert|
  json.extract! alert, :query, :user_id
  json.url alert_url(alert, format: :json)
end
