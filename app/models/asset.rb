class Asset < ApplicationRecord

  include Zippable

  mount_uploader :file, AssetUploader
  attr_accessor :extensions
  validates :extensions, length: { minimum: 1 }
  validate :validate_formats


  def validate_formats
    extensions.each do |ext|
      errors.add(:extensions, "Sorry, we can't convert file into this format - #{ext}") unless $extension_whitelist.include?(ext)
    end
  end

  def convert
    asset = MiniMagick::Image.open(file.path)
    files = extensions.map do |ext|
      asset.format(ext)
      new_file = new_ext_file(ext)
      new_path = new_file_path(new_file)
      asset.write(new_path)
      new_file
    end

    if files.length > 1
      zipfile_name = new_file_path(new_ext_file('zip'))
      generate_zip(zipfile_name, file.store_dir, files)
    else
      new_file_path(files.first)
    end
  end

  def new_file_path(new_file)
    file.store_dir + "/" + new_file
  end

  def new_ext_file(ext)
    new_file = file.filename.split(".")
    new_file[-1] = ext
    new_file.join(".")
  end
end
