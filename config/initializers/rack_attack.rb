class Rack::Attack
  throttle('req/ip', limit: Settings.rack_attack.limit, period: Settings.rack_attack.period) do |req|
    req.ip
  end
end
