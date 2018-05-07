require 'rest-client'

class Spider
  def self.start
    r = RestClient.post 'http://api.008shenqi.com/api/xtools/x008/device/v1', {time: Time.now.to_i, 
      id: 27266, imei: '714254171108722', ' MANUFACTURER': 'Huawei'}
    
    puts r.body
    # res = JSON.parse(r.body)
    #
    # model = res["model"]
    # if model.present?
    #   count = DeviceInfo.where(model: model).count
    #   if count == 0
    #     DeviceInfo.create!(board: res["board"],
    #                        brand: res["brand"],
    #                        cpu: res["setCpuName"],
    #                        cpu2: res["arch"],
    #                        device: res["device"],
    #                        display: "",
    #                        fingerprint: res["fingerprint"],
    #                        hardware: res["hardware"],
    #                        product_model: "",
    #                        manufacturer: res["manufacturer"],
    #                        model: model,
    #                        product: res["product"],
    #                        bootloader: res["bootloader"],
    #                        host: "",
    #                        build_tags: "",
    #                        incremental: ""
    #                        )
    #   end
    # end
    #
  end
end

Spider.start