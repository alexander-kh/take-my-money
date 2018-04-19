### Take My Money: Accepting Payments on the Web 
##### by Noel Rappin

The code from "Take My Money" book, published by the Pragmatic Bookshelf.
Copyrights apply to this code. It may not be used to create training material, courses, books, articles, and the like. Contact the publisher if you are in doubt.
Visit http://www.pragmaticprogrammer.com/titles/nrwebpay for more book information.

In process: completed chapters 11/13

**Versions used:**

  * Ruby: 2.5.0
  * Rails: 5.1.4
  * PostgreSQL: 10.1
  * RSpec: 3.7

**Configuration:**

  * Create database:
  ```
  bundle exec rails db:create
  ```
  * Run migrations:
  ```
  bundle exec rails db:migrate
  ```
  * Install ruby gems:
  ```
  bundle install
  ```
  
**Testing:**

  * Using RSpec testing library:

    * unit tests
    
    * integration tests using Capybara
    ```
    bundle exec rspec
    ````