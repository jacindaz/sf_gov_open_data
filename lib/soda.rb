client = SODA::Client.new({:domain => "data.sfgov.org", app_token: Rails.application.secrets.soda_app_token})
data = client.get("5cei-gny5", { "$limit" => 10})
