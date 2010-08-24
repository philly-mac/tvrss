DataMapper.logger = logger

case Padrino.env
  when :development then DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://" + Padrino.root('db', "tvrss_development.db"))
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://" + Padrino.root('db', "tvrss_production.db"))
  when :test        then DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://" + Padrino.root('db', "tvrss_test.db"))
end
