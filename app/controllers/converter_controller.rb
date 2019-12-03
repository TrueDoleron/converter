# frozen_string_literal: true

class ConverterController < ApplicationController

  def new
    @asset = Asset.new(asset_params)
    if @asset.save
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

  def asset_params
    params.require(:asset).permit(:file, :extensions => [])
  end

end