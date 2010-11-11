DataMapper.logger = logger

case Padrino.env
  when :test        then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:@localhost/tvrss_ivercore_test")
  when :development then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:@localhost/tvrss_ivercore_dev")
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:@localhost/tvrss_ivercore")
end

