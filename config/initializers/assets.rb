# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')


# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( statics.js )
Rails.application.config.assets.precompile += %w( marker-clustering.js )
# Rails.application.config.assets.precompile += %w( viewers.js )
Rails.application.config.assets.precompile += %w( iamport.js )
Rails.application.config.assets.precompile += %w( application.js.erb )
Rails.application.config.assets.precompile += %w( errors.scss )
Rails.application.config.assets.precompile += %w( errors.js )
Rails.application.config.assets.precompile += %w( policies.scss )
Rails.application.config.assets.precompile += %w( policies.js )
Rails.application.config.assets.precompile += %w( infinite-scroll.js )


Rails.application.config.assets.precompile += %w( index.css )

Rails.application.config.assets.precompile += %w( review/form.js.erb )
Rails.application.config.assets.precompile += %w( review/form_review.js.erb )

Rails.application.config.assets.precompile += %w( mypage.js )

# Rails.application.config.assets.precompile += %w( s_core_dream_light/s_core_dream.scss )