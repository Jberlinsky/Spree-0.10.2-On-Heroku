SUMMARY
=======

Spree is a complete open source commerce solution for Ruby on Rails.
It was developed by Sean Schofield under the original name of Rails
Cart before changing its name to Spree.

Refer to the [Spree ecommerce project page](http://spreecommerce.com) 
to learn more.


QUICK START
===========

1. Clone this repository

2. Edit vendor/spree/app/models/image.rb to reflect your Amazon S3 credentials

3. Create a heroku application

				heroku create --stack bamboo-ree-1.8.7 --remote bamboo

4. Push the application to Heroku. This will take a while, because Heroku has to load all of the gems

				git push bamboo master

5. Bootstrap

        heroku rake db:bootstrap

6. Create an administrator

				heroku rake db:admin:create

