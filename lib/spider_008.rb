require 'rest-client'

class Spider
  def self.start
    r = RestClient.post 'http://api.008shenqi.com/api/xtools/x008/device/v1', {time: Time.now.to_i, 
      id: 27266, imei: '714254171108722', ' MANUFACTURER': 'Huawei'}
    puts r.body
  end
end

Spider.start