# encoding: utf-8

class AvatarUploader < BaseUploader

  version :large do
    resize_to_limit(600, 600)
  end

  version :thumb do
    process :crop
    resize_to_fill(160, 160)
  end
  
  def default_url
    "/assets/" + [version_name, "default_avatar.png"].compact.join('_')
  end
  
  def filename
    "#{model.id}.#{file.extension.downcase}" if file
  end

  def crop
    if model.crop_x.present?
      resize_to_limit(600, 600)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

end
