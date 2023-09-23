require 'active_record'

# データベースの設定
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/infinite_insight_engine.sqlite3'
)

# Userモデルの定義
class User < ActiveRecord::Base
end
