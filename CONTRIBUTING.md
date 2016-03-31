# Contributing to Social Golem

## Contributing Code and Docs

Before working on anew feature or a bug, please browse [existing issues](https://github.com/densitylabs/socialgolem/pulls) to see whether it has been previously discussed. If the change in question is a bigger one, It's always good to discuss before you starting working on it.

### Creating Development Environment

go to https://github.com/densitylabs/socialgolem and fork and `git clone` the project.

Add a new entry your `/etc/hosts` so you can run the app like http://socialgolem.io.dev:3000

```
127.0.0.1       socialgolem.io.dev
```

Create a [twitter app](https://apps.twitter.com/) and populate `config/twitter_conf.yml`

Run the server

```
$ rails s -p 3000 -b 127.0.0.1
```

Open http://socialdolem.io.dev


### Making Changes

Please make sure your changes follow [Ruby style guide](https://github.com/styleguide/ruby). We use [Rubocop](https://github.com/bbatsov/rubocop)

### Testing

Before opening a pull request, please make sure the test suite passes. You should also add tests for any new features and bug fixes

### Running all tests

```
bundle exec rspec spec
```

 Don't forget to add yourself to [AUTHORS](AUTHORS.md)!
