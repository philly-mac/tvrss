DataMapper.logger = logger

case Padrino.env
  when :development then DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://manman:don040609@localhost/tvrss_development.db")
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://manman:don040609@tvrss_production.db")
  when :test        then DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://manman:don040609@tvrss_test.db")
end
