## builtbyswift.com

The website for Swift Industries. Runs on Heroku.

### Deployment

    $ git push heroku
    $ heroku run console
    >> Rails.cache.clear
    >> exit

If the assets get updated, the css and js will 404.
Clearing the cache will fix this issue.

### Start for development

Manually...

    $ rails s thin
    
Or, use pow.

### Test on IE via Virtual Box

Yes, do this. Also, use xip.io to get to swift.dev if you're using pow.

### Do tests work?

Yes, but only unit tests.

### Database migrations

    $ heroku run rake db:migrate
    $ heroku restart