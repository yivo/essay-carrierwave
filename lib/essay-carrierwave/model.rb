# encoding: utf-8
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
    active_record.try(:uploaders).present?
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
    !!with(:globalize) { |g| g.active_record_for_translations.features.has_carrierwave_uploaders? }
  end

  def carrierwave
    @carrierwave || begin
      @carrierwave = CarrierWave.new(env) if has_carrierwave_uploaders?
    end
  end

  serialize do
    { has_carrierwave_uploaders:            has_carrierwave_uploaders?,
      has_own_carrierwave_uploaders:        has_own_carrierwave_uploaders?,
      has_translated_carrierwave_uploaders: has_translated_carrierwave_uploaders?,
      carrierwave:                          carrierwave.try(:to_hash) }
  end

  class CarrierWave < Base
    # class Article
    #   mount_uploader :poster, PosterUploader
    # end
    #
    # Article.features.carrierwave.table => { poster: PosterUploader }
    #
    def table
      active_record.uploaders
    end

    # class Article
    #   mount_uploader :poster, PosterUploader, mount_on: :poster_path
    # end
    #
    # Article.features.carrierwave.options => { poster: { mount_on: :poster_path } }
    #
    def options
      active_record.uploader_options
    end

    # class Article
    #   mount_uploader :poster, PosterUploader, mount_on: :poster_path
    # end
    #
    # Article.features.carrierwave.uploader_for(:poster_path) => PosterUploader
    #
    def uploader_for(attribute)
      if pair = pair_for(attribute.to_sym)
        table[pair.first]

      else
        send_to_translation(:uploader_for, attribute.to_sym)
      end
    end

    # class Article
    #   mount_uploader :poster, PosterUploader, mount_on: :poster_path
    # end
    #
    # Article.features.carrierwave.accessor_for(:poster_path) => :poster
    #
    def accessor_for(attribute)
      attribute = attribute.to_sym

      if table.has_key?(attribute)
        attribute

      elsif pair = pair_for(attribute)
        pair.first

      else
        send_to_translation(:accessor_for, attribute)
      end
    end

    serialize do
      { table:   table,
        options: options }
    end

  private
    def pair_for(mounted_on_or_attr_name)
      all_options = options
      key         = mounted_on_or_attr_name.to_sym

      if all_options.has_key?(key)
        {key => all_options[key]}
      else
        all_options.find do |name, options|
          options.is_a?(Hash) && (mount_on = options[:mount_on]) && mount_on.to_sym == key
        end
      end
    end

    def send_to_translation(method, *args)
      active_record.features.with(:globalize) do |g|
        g.active_record_for_translations.features.carrierwave.send(method, *args)
      end
    end
  end
end
