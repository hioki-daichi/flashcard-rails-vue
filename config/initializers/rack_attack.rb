class Rack::Attack
  throttle('req/ip', limit: 30, period: 60.seconds) do |req|
    req.ip
  end
end
