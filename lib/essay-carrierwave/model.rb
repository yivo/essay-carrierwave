# frozen_string_literal: true
class Essay::ModelFeatures
  def has_uploaders?
    has_carrierwave_uploaders?
  end

  def has_carrierwave_uploaders?
    has_own_carrierwave_uploaders? || has_translated_carrierwave_uploaders?
  end

  # class Article
  #   mount_uploader :poster, PosterUploader
  # end
  #
  # Article.features.has_own_carrierwave_uploaders?        => true
  # Article.features.has_translated_carrierwave_uploaders? => false
  #
  def has_own_carrierwave_uploaders?
    model_class.try(:uploaders).present?
  end

  # class Article
  #   translates :poster
  #   Translation.mount_uploader :poster, PosterUploader
  # end
  #
  # Article.features.has_own_carrierwave_uploaders?        => false
  # Article.features.has_translated_carrierwave_uploaders? => true
  #
  def has_translated_carrierwave_uploaders?
    !!with(:globalize) { |g| g.model_class_for_translations.features.has_carrierwave_uploaders? }
  end

  def carrierwave
    @carrierwave || begin
      @carrierwave = CarrierWave.new(env) if has_carrierwave_uploaders?
    end
  end

  serialize do
    {
      has_carrierwave_uploaders:            has_carrierwave_uploaders?,
      has_own_carrierwave_uploaders:        has_own_carrierwave_uploaders?,
      has_translated_carrierwave_uploaders: has_translated_carrierwave_uploaders?,
      carrierwave:                          carrierwave.try(:to_hash)
    }
  end

  class CarrierWave < Base
    # class Article
    #   mount_uploader :poster, PosterUploader
    # end
    #
    # Article.features.carrierwave.table => { poster: PosterUploader }
    #
    def table
      model_class.uploaders
    end

    # class Article
    #   mount_uploader :poster, PosterUploader, mount_on: :poster_path
    # end
    #
    # Article.features.carrierwave.options => { poster: { mount_on: :poster_path } }
    #
    def options
      model_class.uploader_options
    end

    # class Article
    #   mount_uploader :poster, PosterUploader, mount_on: :poster_path
    # end
    #
    # Article.features.carrierwave.uploader_for(:poster_path) => PosterUploader
    #
    def uploader_for(attr_name)
      attr_name = convert_key(attr_name)

      if pair = pair_for(attr_name)
        table[pair.first]

      else
        send_to_translation(:uploader_for, attr_name)
      end
    end

    # class Article
    #   mount_uploader :poster, PosterUploader, mount_on: :poster_path
    # end
    #
    # Article.features.carrierwave.accessor_for(:poster_path) => :poster
    #
    def accessor_for(attr_name)
      attr_name = convert_key(attr_name)

      if table.has_key?(attr_name)
        attr_name

      elsif pair = pair_for(attr_name)
        pair.first

      else
        send_to_translation(:accessor_for, attr_name)
      end
    end

    serialize do
      {
        table:   table,
        options: options
      }
    end

  private
    def pair_for(mounted_on_or_attr_name)
      all_options = options
      key = convert_key(mounted_on_or_attr_name)

      if all_options.has_key?(key)
        {key => all_options[key]}
      else
        all_options.find do |name, options|
          options.is_a?(Hash) && (mount_on = options[:mount_on]) && mount_on.to_sym == key
        end
      end
    end

    def convert_key(key)
      key.is_a?(Symbol) ? key : key.to_sym
    end

    def send_to_translation(method, *args)
      model_features.with(:globalize) do |g|
        g.model_class_for_translations.features.carrierwave.send(method, *args)
      end
    end
  end
end
