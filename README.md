# ActiveRecord を使用した Ruby プロジェクトのセットアップ手順

## 1. プロジェクトディレクトリの作成

```sh
mkdir infinite_insight_engine
cd infinite_insight_engine
```

## 2. Gemfile の作成

```sh
touch Gemfile
```

Gemfile の内容:

```ruby
# Gemfile

source 'https://rubygems.org'

gem 'sqlite3'
gem 'activerecord'
gem 'rake'
```

## 3. Bundle install

```sh
bundle install
```

## 4. ディレクトリ構造の作成

```sh
mkdir db
mkdir db/migrate
touch app.rb
touch Rakefile
```

## 5. Rakefile の設定

Rakefile の内容:

```ruby
require 'active_record'
require 'rake'
require_relative 'app.rb'

namespace :db do
  task :load_config do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/infinite_insight_engine.sqlite3'
    )
  end

  desc 'Create a new migration file'
  task :create_migration, [:name] => :load_config do |_, args|
    name = args[:name]
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "#{timestamp}_#{name}.rb"
    filepath = File.join(File.dirname(__FILE__), 'db/migrate', filename)

    open(filepath, 'w') do |file|
      file.puts <<-MIGRATION
      class #{name.camelize} < ActiveRecord::Migration[7.0]
        def change
        end
      end
      MIGRATION
    end

    puts "Created migration #{filename}"
  end

  desc 'Migrate the database'
  task migrate: :load_config do
    migration_dir = File.join(File.dirname(__FILE__), 'db/migrate')
    migration_context = ActiveRecord::MigrationContext.new(migration_dir, ActiveRecord::SchemaMigration)
    migration_context.migrate
  end
end
```

## 6. マイグレーションファイルの作成

```sh
bundle exec rake db:create_migration[create_users]
```

作成されたマイグレーションファイル（例: `db/migrate/20230922235550_create_users.rb`）を編集し、以下の内容を追加します。

```ruby
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.timestamps null: false
    end
  end
end
```

## 7. データベースマイグレーションの実行

```sh
bundle exec rake db:migrate
```

## 8. モデルの作成と操作（app.rb）

app.rb の内容:

```ruby
require 'active_record'
require 'sqlite3'

# データベースの設定
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/infinite_insight_engine.sqlite3'
)

# Userモデルの定義
class User < ActiveRecord::Base
end

# レコードの操作例
user = User.create(username: 'example', email: 'example@example.com')
found_user = User.find_by(username: 'example')
found_user.update(email: 'new_email@example.com')
found_user.destroy
```

## 9. レコードの操作スクリプトの実行

```sh
ruby app.rb
```

## 10. sqlite3 でデータベースの確認

```sh
sqlite3 db/infinite_insight_engine.sqlite3
```

## 11. .gitignore の作成（オプショナル）

このプロジェクトでは特に隠したいファイルはないかもしれませんが、一般的に`.gitignore`には以下のような内容が含まれることがあります。

```
*.log
*.sqlite3
db/*.sqlite3
*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/spec/examples.txt
/test/tmp/
/test/version_tmp/
/tmp/
```
