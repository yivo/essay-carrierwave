class Essay::AttributeRoles
  def has_uploader?
    has_carrierwave_uploader?
  end

  def has_carrierwave_uploader?
    !!model_features.with(:carrierwave) { |cw| cw.uploader_for(this_attribute.name) }
  end

  def carrierwave
    @carrierwave || begin
      @carrierwave = HasCarrierWaveUploader.new(env) if has_carrierwave_uploader?
    end
  end

  serialize do
    {
      has_carrierwave_uploader: has_carrierwave_uploader?,
      carrierwave:              carrierwave.try(:to_hash)
    }
  end

  class HasCarrierWaveUploader < Base
    # class Article
    #   mount_uploader :poster, PosterUploader
    # end
    #
    # Article.attribute_roles[:poster].carrierwave.uploader => PosterUploader
    #
    def uploader
      top_feature.uploader_for(this_attribute.name)
    end

    # class Article
    #   mount_uploader :poster, PosterUploader
    # end
    #
    # Article.attribute_roles[:poster].carrierwave.mounted_as => :poster
    #
    def mounted_as
      top_feature.accessor_for(this_attribute.name)
    end

    serialize do
      {
        uploader:   uploader.name,
        mounted_as: mounted_as
      }
    end

  private
    def top_feature
      model_features.carrierwave
    end
  end
end