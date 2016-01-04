```ruby
  class Article < ActiveRecord::Base
    mount_uploader :poster, PosterUploader
  end

  Article.features.has_carrierwave_uploaders?                   # => true
  Article.attribute_roles[:poster].has_carrierwave_uploader?    # => true
  Article.attribute_roles[:poster].carrierwave.mounted_on?      # => :poster
```

## Gemfile
```ruby
gem 'essay-carrierwave', github: 'yivo/essay-carrierwave'
```