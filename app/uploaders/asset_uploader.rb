# frozen_string_literal: true

class AssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "#{Rails.root}/public/uploads/#{model.class}/#{model.id}/#{mounted_as}"
  end

  def extension_whitelist
    $extension_whitelist
  end

  def content_type_whitelist
    /image\//
  end
end
  