Just an app to presentate how rails can work with Hamdown

# How to run the application

```bash
gem install bundler -v 1.16.5
bundle exec rails s
open 'http://localhost:3000'
```

# How does it work?

Firstly, add hamdown-engine and tilt gem to your Gemfile

```ruby
gem 'hamdown-engine', branch: 'development', github: 'kopylovvlad/hamdown'
gem 'tilt', branch: 'development', github: 'kopylovvlad/tilt'
```

Then, you have to register template_handler
[the link how to do it](https://github.com/kopylovvlad/rails_app_with_hamdown/blob/master/config/initializers/templates.rb)

Then, run rails app and open your browser

```
open 'http://localhost:3000'
```

# Warning

Sure that you use 'hamdown_core' version 0.5.3

If you have some troubles with it, run

```
bundle update --full-index
```
