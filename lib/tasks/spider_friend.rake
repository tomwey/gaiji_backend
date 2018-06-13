require 'rest-client'

namespace :spider do
  desc "开始..."
  task start_friend: :environment do
    10.times do 
      r = RestClient.get 'http://api.dindingame.com:5050/phone/info'
    
      puts r
      res = JSON.parse(r)

      model = res["model"]
      if model.present?
        count = Device.where(model: model).count
        if count == 0
          Device.create!(
                          model: res["model"],
                          hardware: res["hardware"],
                          density: res["density"],
                          abi: res["abi"],
                          resolution: res["resolution"],
                          product_type: res["type"],
                          product_id: res["id"],
                          memory: res["mem"],
                          radio_version: res["radio_version"],
                          dpi: res["dpi"],
                          abi2: res["abi2"],
                          tags: res["tags"],
                          host: res["host"],
                          display: res["display"],
                          board: res["board"],
                          product: res["product"],
                          manufacturer: res["manufacturer"],
                          device: res["device"],
                          brand: res["brand"],
                          user: res["user"],
                          cpu: res["cpu"],
                          sdk_int: res["sdk_int"],
                          sdk_val: res["sdk_val"],
                          release: res["release"],
                          sdk_incremental: res["sdk_incremental"],
                          gl_vendor: res["gl_vendor"],
                          gl_version: res["gl_version"],
                          gl_render: res["gl_render"]
                        )
        end
      end # end if
      
    end # times
    
  end

end
