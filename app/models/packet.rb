class Packet < ActiveRecord::Base
  before_create :generate_unique_id
  def generate_unique_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def device_info
    klass = Object.const_get self.device_info_type
    @device_info ||= klass.find_by(uniq_id: self.device_info_id)
  end
  
  def board
    device_info.try(:board) || ''
  end
  
  def brand
    device_info.try(:brand) || ''
  end
  
  def local_ip
    self[:local_ip] || ROMUtils.create_local_ip
  end
  
  def cpu
    device_info.try(:cpu) || ''
  end
  
  def cpu2
    device_info.try(:cpu2) || device_info.try(:abi) || ''
  end
  
  def abi
    device_info.try(:abi) || ''
  end
  
  def abi2
    device_info.try(:abi2) || ''
  end
  
  def device
    device_info.try(:device)
  end
  
  def display
    device_info.try(:display)
  end
  
  def fingerprint
    device_info.try(:fingerprint)
  end
  
  def release
    device_info.try(:release)
  end
  
  def hardware
    device_info.try(:hardware)
  end
  
  def product_model
    device_info.try(:product_model)
  end
  
  def product_id
    device_info.try(:product_id)
  end
  
  def product_type
    device_info.try(:product_type)
  end
  
  def manufacturer
    device_info.try(:manufacturer)
  end
  
  def model
    device_info.try(:model)
  end
  
  def product
    device_info.try(:product)
  end
  
  def bootloader
    device_info.try(:bootloader)
  end
  
  def host
    device_info.try(:host)
  end
  
  def tags
    device_info.try(:tags)
  end
  
  def user
    device_info.try(:user)
  end
  
  def firmware
    device_info.try(:firmware) || device_info.try(:radio_version)
  end
  
  def radio_version
    self.firmware
  end
  
  def build_tags
    device_info.try(:build_tags) || self.tags
  end
  
  def incremental
    device_info.try(:incremental)
  end
  
  def sdk_incremental
    self.incremental || device_info.try(:sdk_incremental)
  end
  
  def gl_vendor
    device_info.try(:gl_vendor)
  end
  
  def gl_version
    device_info.try(:gl_version)
  end
  
  def gl_render
    device_info.try(:gl_render)
  end
  
end
