json.extract! session, :id, :name, :created_at, :updated_at
json.url session_url(session, format: :json)
