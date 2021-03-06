# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )


Rails.application.config.assets.precompile += %w(
  twitter_card.css
  simplePagination.css
  twitter_card_overwrites.css

  cable.js
  channels/twitter_user_info.js
  twitter_users/show.js
  jquery.simplePagination.js
  materialize/js/global.js
  materialize/js/forms.js
  materialize/js/dropdown.js
  materialize/js/easing.js
  materialize/js/jquery.easing.1.3
  follow_users.js
)
