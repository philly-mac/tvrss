DataMapper.logger = logger

case Padrino.env
  # We use sqlite in test and dev because it is easy to use and set up for simple projects
  when :test        then DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite:///#{Padrino.root}/db/tvrss_test.db")
  when :development then DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite:///#{Padrino.root}/db/tvrss_dev.db")
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/tvrss")
end

