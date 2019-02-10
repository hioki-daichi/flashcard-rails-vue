namespace :db do
  desc "Dumps the database to tmp/BRANCH_NAME.dump"
  task dump: :environment do
    "#{bin}/pg_dump #{common_options} --format=c > #{filename}".tap { |cmd| puts cmd; system cmd }
  end

  desc "Restores the database dump at tmp/BRANCH_NAME.dump."
  task restore: :environment do
    fail "File not found at #{filename}" unless File.exist?(filename)

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke

    "#{bin}/pg_restore #{common_options} #{filename}".tap { |cmd| puts cmd; system cmd }
  end

  private

  def filename
    result = system("git symbolic-ref HEAD 2>/dev/null")
    branch_name = (result ? `git rev-parse --abbrev-ref HEAD` : `git describe --all --exact-match HEAD`).chomp.gsub("/", "__")

    "#{Rails.root}/tmp/#{branch_name}.dump"
  end

  def common_options
    host = ActiveRecord::Base.connection_config[:host]
    port = ActiveRecord::Base.connection_config[:port]
    username = ActiveRecord::Base.connection_config[:username]
    dbname = ActiveRecord::Base.connection_config[:database]

    "--host #{host} --port #{port} --username #{username} --dbname #{dbname} --verbose --clean --no-owner --no-acl"
  end

  def bin
    "/usr/local/Cellar/postgresql/10.3/bin"
  end
end
