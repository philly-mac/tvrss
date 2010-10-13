DataMapper.logger = logger

case Padrino.env
  when :development then DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://macman:don040609@localhost/tvrss_ivercore_dev")
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://macman:don040609@localhost/tvrss_ivercore_prod")
  when :test        then DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://macman:don040609@localhost/tvrss_ivercore_test")
end
