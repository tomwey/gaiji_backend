require 'rest-client'
module API
  module V1
    class NewbieAPI < Grape::API
      
      resource :data, desc: '获取基本数据接口' do
        desc "获取手机号"
        get :mobile do
          tel = ROMUtils.create_tel_number
          { tel: tel.to_s }
        end # end get mobile
      end
      
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
      
      resource :tasks, desc: '任务相关接口' do
        desc "获取任务列表"
        params do
          requires :type,type: Integer,desc: '任务类型，值为1或2；1 表示新增任务，2 表示留存任务'
          optional :day, type: String, desc: '任务日期，例如：2018-01-02'
        end
        get do
          type = params[:type].to_i
          
          types = %w(1 2)
          unless types.include?(type.to_s)
            return render_error(-1, '不正确的Type参数')
          end
          
          task_classes = %w(NewTask RemainTask)
          
          klass = Object.const_get task_classes[type-1]
          
          @tasks = klass.where(opened: true).order('id desc')
          if params[:day]
            @tasks = @tasks.where(task_date: params[:day])
          end
          
          if type == 2
            @tasks = @tasks.where('join_task_count > 0')
          end
          
          render_json(@tasks, API::V1::Entities::CommonTask)
          
        end # end get tasks
      end # end resource
      
      resource :rom, desc: '数据相关接口' do
        desc "生成返回一条改机数据"
        params do
          optional :task_id, type: Integer, desc: '任务ID'
        end
        post :create_packet do
          carrier_id = ROMUtils.create_carrier_id
          
          os_info = ROMUtils.create_os_info
          ver,sdk = os_info.split(',')
          
          screen,dpi = ROMUtils.create_screen_size
          
          device_info = DeviceInfo.order("RANDOM()").first
          
          @packet = Packet.create!(
            serial: ROMUtils.create_serial,
            android_id: ROMUtils.create_android_id,
            imei: ROMUtils.create_imei,
            sim_serial: ROMUtils.create_sim_serial_for(carrier_id),
            imsi: ROMUtils.create_imsi_for(carrier_id),
            sim_country: ROMUtils.create_sim_country,
            phone_number: ROMUtils.create_tel_number_for(carrier_id),
            carrier_id: carrier_id,
            carrier_name: ROMUtils.create_carrier_name_for(carrier_id),
            network_type: ROMUtils.create_network_type,
            phone_type: ROMUtils.create_phone_type,
            sim_state: ROMUtils.create_sim_state,
            mac_addr: ROMUtils.create_mac_addr,
            bluetooth_mac: ROMUtils.create_bluetooth_mac,
            wifi_mac: ROMUtils.create_wifi_mac,
            wifi_name: ROMUtils.create_wifi_name,
            os_version: ver,
            sdk_value: sdk,
            sdk_int: sdk,
            screen_size: screen,
            screen_dpi: dpi,
            device_info_id: device_info.try(:uniq_id),
            device_info_type: 'DeviceInfo',
            local_ip: ROMUtils.create_local_ip
          )
          
          task = NewTask.find_by(uniq_id: params[:task_id])
          if task.blank? or (task.task_count <= task.complete_count)
            return render_error(4004, '任务不存在或已经做完')
          end
          
          if task.present?
            NewTaskLog.where(task_id: task.uniq_id, proj_id: task.proj_id, packet_id: @packet.uniq_id).first_or_create!
          end
          
          render_json(@packet, API::V1::Entities::Packet, { task: task })
        end # end create
        
        desc "生成返回一条改机数据2"
        params do
          optional :task_id, type: Integer, desc: '任务ID'
          optional :device,  type: String, desc: '设备品牌'
        end
        post :create_packet_2 do
          task = NewTask.find_by(uniq_id: params[:task_id])
          if task.blank? or (task.task_count <= task.complete_count)
            return render_error(4004, '任务不存在或已经做完')
          end
          
          bundle_id = task.project.try(:bundle_id)
          
          bids = bundle_id.blank? ? [] : bundle_id.split(',')
          
          if params[:device] && params[:device].present?
            device = Device.where('lower(brand) = ?', params[:device].downcase).order("RANDOM()").first
          else
            device = Device.order("RANDOM()").first
          end
          
          carrier_id = ROMUtils.create_carrier_id
          
          os_info = ROMUtils.create_os_info
          ver,sdk = os_info.split(',')
          
          @packet = Packet.create!(
            serial: ROMUtils.create_serial,
            android_id: ROMUtils.create_android_id,
            imei: ROMUtils.create_imei,
            sim_serial: ROMUtils.create_sim_serial_for(carrier_id),
            imsi: ROMUtils.create_imsi_for(carrier_id),
            sim_country: ROMUtils.create_sim_country,
            phone_number: ROMUtils.create_tel_number_for(carrier_id),
            carrier_id: carrier_id,
            carrier_name: ROMUtils.create_carrier_name_for(carrier_id),
            network_type: ROMUtils.create_network_type,
            phone_type: ROMUtils.create_phone_type,
            sim_state: ROMUtils.create_sim_state,
            mac_addr: ROMUtils.create_mac_addr,
            bluetooth_mac: ROMUtils.create_bluetooth_mac,
            wifi_mac: ROMUtils.create_wifi_mac,
            wifi_name: ROMUtils.create_wifi_name,
            os_version: ver,#device.release,
            sdk_value: sdk,#device.sdk_val,
            sdk_int: sdk,#device.sdk_int,
            screen_size: device.resolution.gsub('x', '*'),
            screen_dpi: device.dpi,
            device_info_id: device.try(:uniq_id),
            device_info_type: 'Device',
            local_ip: ROMUtils.create_local_ip
          )
          
          if task.present?
            NewTaskLog.where(task_id: task.uniq_id, proj_id: task.proj_id, packet_id: @packet.uniq_id).first_or_create!
          end
          
          render_json(@packet, API::V1::Entities::Packet, { task: task })
          
        end # end create
        
        desc "上传刷量任务数据"
        params do
          requires :id, type: String, desc: '改机数据ID'
          requires :data, type: String, desc: '备份数据'
        end
        post :upload_data do
          @log = NewTaskLog.where(uniq_id: params[:id]).first
          if @log.blank?
            return render_error(4004, '不存在的刷量任务记录')
          end
          @log.extra_data = params[:data]
          @log.save!
          
          render_json_no_data
          
        end # end upload data
        
        # desc "上传刷单日志"
        # params do
        #   requires :proj_id,  type: Integer, desc: '项目ID'
        #   requires :packet_id,type: Integer, desc: '改机数据ID'
        #   optional :extras,   type: String,  desc: '额外的数据'
        # end
        # post :upload_log do
        #   project = Project.find_by(uniq_id: params[:proj_id])
        #   if project.blank?
        #     return render_error(4004, '项目不存在')
        #   end
        #
        #   packet = Packet.find_by(uniq_id: params[:packet_id])
        #   if packet.blank?
        #     return render_error(4004, '改机数据不存在')
        #   end
        #
        #   log = TaskLog.create(project_id: project.uniq_id, packet_id: packet.uniq_id, extras_data: params[:extras])
        #   if log
        #     { code: 0, message: 'ok', data: { log_id: log.uniq_id } }
        #   else
        #     render_error(-1, '上传失败')
        #   end
        #
        # end # end upload_log
        #
        # desc "获取所有留存任务" # 0001, 0002
        # params do
        #   optional :day, type: String, desc: '某一天的日期'
        # end
        # get :remain_tasks do
        #   @tasks = RemainTask.order('id desc')
        #   if params[:day]
        #     @tasks = @tasks.where(created_at: "#{params[:day]} 00:00:00".."#{params[:day]} 23:59:59")
        #   end
        #   render_json(@tasks, API::V1::Entities::RemainTask)
        # end # end
        
        desc "获取某留存任务的一条改机数据"
        params do
          requires :task_id, type: Integer, desc: '留存任务ID'
          optional :date, type: String, desc: '做留存的日期，如果不传，默认为今天的日期'
        end
        get :remain_packet do
          task = NewTask.find_by(uniq_id: params[:task_id])
          if task.blank?
            return render_error(4004, '任务不存在')
          end
          
          if task.remain_ratios.blank? or task.remain_ratios.split(',').empty?
            return render_error(3001, '任务还未设置留存率')
          end
          
          date = params[:date]
          if date.blank?
            date = Time.zone.now.strftime('%Y-%m-%d')
          end
          
          key = "#{params[:task_id]}:#{date}"
          values = $redis.get(key)
          
          if values.blank?
            ids = []
            
            ratios = task.remain_ratios.split(',')
            ratios.each_with_index do |ratio,index|
              time = (date.to_date - (index + 1).days)
              
              total_count = NewTaskLog.where(proj_id: task.proj_id, visible: true)
                              .where(created_at: time.beginning_of_day..time.end_of_day).count
              
              ratio = ratio.to_f
              size = ratio >= 100 ? total_count : ( (total_count * ratio / 100.0).to_i + 18 )
              
              logids = NewTaskLog.where(proj_id: task.proj_id, visible: true)
                            .where(created_at: time.beginning_of_day..time.end_of_day)
                            .order('RANDOM()').limit(size).pluck(:id)
              ids = ids + logids
            end
            
          else
            ids = values.split(',')
          end
          
          if ids.blank? or ids.empty?
            return render_error(4004, '留存任务已做完')
          end
          
          logid = ids.sample
          
          @log = NewTaskLog.find_by(id: logid)
          if @log.blank?
            return render_error(4004, '任务记录不存在')
          end
          
          @log.do_remain_at = Time.zone.now
          @log.save!
          
          ids.delete(logid)
          if ids.any?
            $redis.set key, ids.join(',')
          else
            $redis.del key
          end
          
          render_json(@log.packet, API::V1::Entities::Packet, { task: task, extra_data: @log.extra_data })
          
          # @log = RemainTaskLog.where(task_id: task.uniq_id, in_use: false).order('RANDOM()').first
          # if @log.blank?
          #   return render_error(4004, '没有留存任务')
          # end
          # 
          # @log.in_use = true
          # @log.save!
          #
          # @log.task.increment_complete_count if @log.task.present?
          #
          # render_json(@log.packet, API::V1::Entities::Packet, { task: task, extra_data: @log.extra_data })
        end
        
        # desc "获取一条某个项目的留存改机数据"
        # params do
        #   requires :proj_id, type: Integer, desc: '项目ID'
        #   requires :ratio,   type: Integer, desc: '留存比率，传一个整数值'
        #   requires :time,    type: String,  desc: '留存任务时间'
        # end
        # get :remain_packet do
        #
        # end # end remain_packet
        
      end # end resource
      
    end
  end
end