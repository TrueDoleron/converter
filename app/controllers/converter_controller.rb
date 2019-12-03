# frozen_string_literal: true

class ConverterController < ApplicationController

  def new
    @asset = Asset.new(asset_params)
    if validate_formats && @asset.save
      send_file @asset.convert
    else 
      render json: {
        status: "error",
        code: 666,
        message: @asset.errors.present? && @asset.errors.full_messages.join('. ') || "Sorry, something went wrong. Repeat at a later date."
      }
    end
  end

  private

  def validate_formats
    asset_params[:extensions].each do |ext|
      return false unless $extension_whitelist.include?(ext)
    end
    true
  end

  def asset_params
    params.require(:asset).permit(:file, :extensions => [])
  end

end