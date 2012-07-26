## builtbyswift.com

The website for Swift Industries. Runs on Heroku.

### Deployment

    $ git push heroku
    $ heroku run console
    >> Rails.cache.clear
    >> exit

### Start for development

    $ rails s thin

### Do tests work

Yes, but only unit tests.

### Database migrations

    $ heroku run rake db:migrate
    $ heroku restart