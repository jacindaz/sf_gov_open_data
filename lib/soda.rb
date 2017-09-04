client = SODA::Client.new({:domain => "data.sfgov.org"})
client.get("cuks-n6tp", { "$limit" => 1, "$order" => { "DESC" => "date" }})
