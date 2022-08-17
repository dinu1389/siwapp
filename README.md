# Siwapp

[![Build Status](https://travis-ci.org/siwapp/siwapp.svg?branch=master)](https://travis-ci.org/siwapp/siwapp)

Online Invoice Management. See [online demo](https://siwapp-demo.herokuapp.com) (user: demo@example.com, password: secret).

[API Documentation](https://github.com/siwapp/siwapp/blob/master/API_DOC.md)



## SMTP Configuration

In order to be able to send emails through the app, you must configure the following environment variables in your system:

```
SMTP_HOST
SMTP_PORT
SMTP_DOMAIN
SMTP_USER
SMTP_PASSWORD
SMTP_AUTHENTICATION (plain | login | cram_md5)
SMTP_ENABLE_STARTTLS_AUTO (set to 1 to enable it)
```

## How to Install on Heroku

First clone the siwapp repository into your computer:

    $ git clone https://github.com/siwapp/siwapp.git
    $ cd siwapp

Create the app in heroku (we suppose in the terminal your are logged
in heroku). Here we call the app "siwapp-demo", but choose whatever
you like.

    $ heroku apps:create siwapp-demo
    $ heroku apps:create --region eu --buildpack heroku/ruby siwapp-demo
    $ heroku addons:create heroku-postgresql
    $ heroku addons:create scheduler:standard

Push the code to heroku, and setup database.

    $ git push heroku
    $ heroku run rake db:setup

Finally create an user to be able to login into the app.

    $ heroku run "rake siwapp:user:create['demo','demo@example.com','secret_password']"

If you want the recurring invoices to be generated automatically, you have to setup the heroku scheduler addon:

    $ heroku addons:open scheduler

Add a new job, and put "rake siwapp:generate_invoices"

That's it! You can enjoy siwapp now entering on your heroku app url.

    $ heroku apps:open


Issues:

https://stackoverflow.com/questions/36608732/not-able-to-install-capybara-webkit-using-bundle-install-command-in-rails-4

    sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x


https://stackoverflow.com/questions/17150064/how-to-check-if-the-database-exists-or-not-in-rails-before-doing-a-rake-dbsetup


https://products.aspose.com/words/family/

https://pragmaticstudio.com/tutorials/using-active-storage-in-rails

https://pragmaticstudio.com/tutorials/using-active-storage-in-rails

https://gist.github.com/lorenadl/a1eb26efdf545b4b2b9448086de3961d


# benchmark

https://dalibornasevic.com/posts/68-processing-large-csv-files-with-ruby

https://stackoverflow.com/questions/9599568/how-to-find-a-specific-row-in-csv

# loop check if exist first

https://stackoverflow.com/questions/31005290/rails-erb-check-if-exist-and-do-each