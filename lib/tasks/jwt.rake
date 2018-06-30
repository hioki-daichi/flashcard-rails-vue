namespace :jwt do
  task :encode, :payload do |t, args|
    puts JsonWebToken.encode(JSON.parse(args[:payload]))
  end

  task :decode, :token do |t, args|
    puts JsonWebToken.decode(args[:token])
  end
end
