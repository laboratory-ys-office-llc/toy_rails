require_relative 'app.rb'

# レコードの作成
user = User.create(username: 'example', email: 'example@example.com')

# レコードの検索
found_user = User.find_by(username: 'example')

pp found_user, found_user.email, found_user.username

# レコードの更新
found_user.update(email: 'new_email@example.com')

# レコードの削除
found_user.destroy
