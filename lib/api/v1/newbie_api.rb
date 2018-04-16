require 'rest-client'
module API
  module V1
    class NewbieAPI < Grape::API
      
      resource :projects, desc: '项目相关接口' do
        desc "获取某个项目的下载地址或下载二维码图片地址"
        get '/:id/download_urls' do
          project = Project.find_by(uniq_id: params[:id])
          if project.blank?
            return render_error(4004, '项目不存在')
          end
          
          { code: 0, message: 'ok', data: project.download_urls }
        end
      end # end resource
      
      resource :rom, desc: '数据相关接口' do
        desc "生成返回一条改机数据"
        post :create_packet do
          { code: 0, message: 'ok', data: {
            serial: '',
            android_id: '',
            imei: '',
            imsi: '',
          } }
        end # end create
        
        desc "上传刷单日志"
        params do
          
        end
        post :upload_log do
        end # end upload_log
        
        desc "获取一条某个项目的留存改机数据"
        params do
        end
        get :remain_packet do
        end # end remain_packet
        
      end # end resource
      
    end
  end
end