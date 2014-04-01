# builtbyswift.com

The website for Swift Industries. Runs on Heroku.

## Deploy

### Production

    $ git push heroku
    $ heroku run console
    >> Rails.cache.clear
    >> exit

If the assets get updated, the CSS and JS will 404.
Clearing the cache will fix this issue.

### Staging

Staging environment is at: https://fierce-island-8829.herokuapp.com/

    $ git push staging saveToCart:master

## Start for development

Manually...

    $ rails s thin

Or, use [pow](//pow.cx).

## Database

### Pull from production to local

    $ heroku pg:pull HEROKU_POSTGRESQL_ORANGE swift-dev

### Push from local to staging

    $ heroku pg:reset HEROKU_POSTGRESQL_CRIMSON --remote staging
    $ heroku pg:push swift-dev HEROKU_POSTGRESQL_CRIMSON --app fierce-island-8829 --remote staging

### Migrate on production

    $ heroku run rake db:migrate --remote heroku
    $ heroku restart --remote heroku

### Migrate on staging

    $ heroku run rake db:migrate --remote staging
    $ heroku restart --remote staging

## Environmental Variables

    $ heroku config:add VAR=value --remote=<staging/heroku>

## Test on IE via Virtual Box

Yes, do this. Also, use xip.io to get to swift.dev if you're using pow.

## Do tests work?

Yes.

