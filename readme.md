[![Travis](https://travis-ci.org/ga-dc/garnet.svg?branch=master)](https://travis-ci.org/ga-dc/garnet/)
Test Travis!
# Garnet

## Local Setup

1. `$ git clone https://github.com/ga-dc/garnet`
- `$ cd garnet`
- `$ bundle install`
- `$ rake db:create`
- `$ rake db:migrate`
- `$ rake db:seed` (or `$ rake db:seed:test_seed` for additional test data)
- `$ bundle exec figaro install`
- [Register a Github application](https://github.com/settings/applications) and update `config/application.yml` to look like this:

    ```
    gh_client_id: "12345"
    gh_client_secret: "67890"
    gh_redirect_url: "http://localhost:3000/github/authenticate"
    ```

9. `$ rspec -f d`
10. `$ rails s`

# Models

![The ERD](http://i.imgur.com/jW4WQQK.png)

## Github.rb

The Github model has an API method. To use it:

```rb
# Gets the current organization's repos
request = Github.new(ENV).api.repos

# Gets the current user's repos
request = Github.new(ENV, session[:access_token]).api.repos
```

It's built on the Octokit gem. For more information [see the Octokit docs](https://github.com/octokit/octokit.rb).

Users can sign up *with* or *without* Github.

If they sign up *with* Github, they cannot update their username, password, e-mail, etc. Every time they subsequently sign in, the Github API is polled for their most recent information, and the database is updated accordingly.

If they sign up *without* Github, they can update their username, password, e-mail, etc. Should they wish to later link Github to their account, they can click the "Link Github account" link, which will poll the database, rewrite their information in the Users table to use their Github username, email, etc. From there their account will behave as if they had originally signed up with Github.

## Tree.rb

The "Group" model inherits from a "Tree" model, which allows nesting -- that is, for a Group to have child Groups and a parent Group.

# User roles in a specific group

- **Owner**: A user with a physical membership to a group where `membership.is_owner == true`
- **Nonowner**: A user with a physical membership to a group where `membership.is_owner == false`
- **Admin**: Trickles down: An owner of a group, or an owner of any of its ancestor groups
- **Nonadmin**: Bubbles up: A nonowner of a group, or a member of any of its descendant groups

# Deployment

When commits are pushed or merged via pull request to master on this repo, [Travis](https://travis-ci.org/ga-dc/garnet)
clones the application, runs `bundle exec rake` to run tests specified in `spec/`.

If all tests pass, travis pushes to the production repo: `git@garnet.wdidc.org:garnet.git`

This triggers a `post-update` hook, which pulls from GitHub's master branch and restarts
unicorn, the application server.

# Troubleshooting

## NewRelic

New Relic monitors the app and provides metrics.  They are available in development mode (/newrelic) and production (rpm.newrelic.com).  It is recommended that you [install newrelic-sysmond on the servers](https://rpm.newrelic.com/accounts/1130222/servers/get_started).

"config/newrelic.yml" was downloaded from rpm.newrelic.com and updated to use `<%= app_name %>`

## RSpec

Use it!
