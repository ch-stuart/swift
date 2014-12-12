# builtbyswift.com

The website for Swift Industries. Runs on Heroku.

## Deploy

### Production

Deploy without clearing cache or migrating db.

    $ rake deploy[heroku,master]

If the assets get updated, the CSS and JS will 404.
Clearing the cache will fix this issue.

Deploy with clearing cache, but not migrating db.

    $ rake deploy[heroku,master,true]

Deploy with clearing cache or migrating db.

    $ rake deploy[heroku,master,true,true]

### Staging

Staging environment is at: https://fierce-island-8829.herokuapp.com/

    $ rake deploy[staging,master]

## Start for development

Manually...

    $ rails s

Or, use [pow](//pow.cx).

## Database

### Pull from production to local

    $ # quit postgres app to kill db connections
    $ dropdb swift-dev
    $ heroku pg:pull HEROKU_POSTGRESQL_ORANGE swift-dev --remote heroku

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

You may need to clear the cache after this.

## Test on IE via Virtual Box

Yes, do this. Also, use xip.io to get to swift.dev if you're using pow.

## Do tests work?

Yes.
