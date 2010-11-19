DataMapper.logger = logger

case Padrino.env
  when :test        then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/tvrss_test")
  when :development then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/tvrss_dev")
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/tvrss")
end

