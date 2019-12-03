module Zippable
  extend ActiveSupport::Concern
  require 'zip'

  def generate_zip(zipfile_name, folder, files)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      files.each do |f|
        zipfile.add(f, File.join(folder, f))
      end
    end
    
    zipfile_name
  end
end
