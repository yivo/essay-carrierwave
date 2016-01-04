```ruby
  class Article < ActiveRecord::Base
    belongs_to :poster
    translates :name, :poster_id
  end

  Article.features.translates_with_globalize?                   # => true

  Article.features.globalize.translated_attribute_names         # => [:name, :poster_id]
  Article.features.globalize.model_class_for_translations       # => Article::Translation
  Article.features.globalize.association_for_translations.name  # => :translations

  Article.attribute_roles[:name].translates_with_globalize?           # => true
  Article.association_roles[:poster].translates_with_globalize?       # => true
  Article.association_roles[:translations].translates_with_globalize? # => false
  Article.association_roles[:translations].translation_for_globalize? # => true
```

## Gemfile
```ruby
gem 'essay-carrierwave', github: 'yivo/essay-carrierwave'
```