# require 'rest-client'
module API
  module V1
    class DatasourceAPI < Grape::API
      resource :ds, desc: '身份证信息，昵称，评论，聊天数据源接口' do
        desc "过滤身份证信息，并返回一条数据"
        params do
          requires :proj_id, type: Integer, desc: '项目ID'
          requires :range,   type: String,  desc: '身份证出生年的范围，值为1950,1980或1950,或者,1980'
        end
        get :idcard_4 do
          @project = Project.find_by(uniq_id: params[:proj_id])
          if @project.blank?
            return render_error(4004, '项目不存在')
          end
          
          key = "idcard:#{@project.uniq_id}:#{params[:range]}"
          id_vals = $redis.get key
          if id_vals.blank?
            @ids = IdcardAccessLog.where(proj_id: @project.uniq_id).pluck(:idcard_id)
            
            first,last = params[:range].split(',')
            if first.present? and last.present?
              ids = Idcard.where.not(id: @ids).where("substring(card_no, 7, 4) != '' and (cast(substring(card_no, 7, 4) as integer) between #{first} and #{last})").limit(10000).pluck(:id)
            elsif first.present? and last.blank?
              ids = Idcard.where.not(id: @ids).where("substring(card_no, 7, 4) != '' and (cast(substring(card_no, 7, 4) as integer) >= #{first}").limit(10000).pluck(:id)
            elsif first.blank? and last.present?
              ids = Idcard.where.not(id: @ids).where("substring(card_no, 7, 4) != '' and (cast(substring(card_no, 7, 4) as integer) <= #{last}").limit(10000).pluck(:id)
            else
              ids = Idcard.where.not(id: @ids).limit(10000).pluck(:id)
            end
          else
            ids = id_vals.split(',')
          end
          
          if ids.blank? or ids.empty?
            return render_error(4004, '身份证已取完')
          end
          
          cid = ids.sample
          
          idcard = Idcard.find_by(id: cid)
          if idcard.blank?
            return render_error(4004, '身份证不存在')
          end
          
          ids.delete(cid)
          if ids.any?
            $redis.set key, ids.join(',')
          else
            $redis.del key
          end
          
          IdcardAccessLog.create!(idcard: idcard.card_no, proj_id: @project.uniq_id, idcard_id: idcard.id)

          {
            id: idcard.card_no,
            name: idcard.name
          }
          
        end
        
        desc "获取一条身份证信息"
        params do
          requires :proj_id, type: Integer, desc: '项目ID'
        end
        get :idcard_3 do
          @project = Project.find_by(uniq_id: params[:proj_id])
          if @project.blank?
            return render_error(4004, '项目不存在')
          end
          
          key = "idcard:#{@project.uniq_id}"
          id_vals = $redis.get key
          if id_vals.blank?
            @ids = IdcardAccessLog.where(proj_id: @project.uniq_id).pluck(:idcard_id)
            ids = Idcard.where('id >= 1001430').where.not(id: @ids).pluck(:id)
          else
            ids = id_vals.split(',')
          end
          
          if ids.blank? or ids.empty?
            return render_error(4004, '身份证已取完')
          end
          
          cid = ids.sample
          
          idcard = Idcard.find_by(id: cid)
          if idcard.blank?
            return render_error(4004, '身份证不存在')
          end
          
          ids.delete(cid)
          if ids.any?
            $redis.set key, ids.join(',')
          else
            $redis.del key
          end
          
          IdcardAccessLog.create!(idcard: idcard.card_no, proj_id: @project.uniq_id, idcard_id: idcard.id)

          {
            id: idcard.card_no,
            name: idcard.name
          }
          
        end
        
        desc "获取一条身份证信息"
        params do
          requires :proj_id, type: Integer, desc: '项目ID'
        end
        get :idcard_2 do
          @project = Project.find_by(uniq_id: params[:proj_id])
          if @project.blank?
            return render_error(4004, '项目不存在')
          end
                    
          @ids = IdcardAccessLog.where(proj_id: @project.uniq_id).pluck(:idcard_id)
          idcard = Idcard.where.not(id: @ids).order('id desc').first
          if idcard.blank?
            return render_error(4004, '无数据')
          end

          IdcardAccessLog.create!(idcard: idcard.card_no, proj_id: @project.uniq_id, idcard_id: idcard.id)

          {
            id: idcard.card_no,
            name: idcard.name
          }
        end # end get idcard 2
        desc "获取一条身份证信息"
        params do
          optional :flag, type: Integer, desc: '是否获取唯一的身份证信息，值为0或1，0表示不一定唯一，1表示获取一条唯一的身份证信息'
          optional :cl, type: Integer, desc: '是否清空历史'
        end
        get :idcard do
          flag = (params[:flag] || 0).to_i
          
          unless %w(0 1).include? flag.to_s
            return render_error(-1, 'flag参数不正确，只能为0或1')
          end
          
          queued = $redis.get('queued')
          ids = []
          if queued.present?
            ids = queued.split(',')
          end
          if flag == 1
            @idcard = Idcard.where.not(card_no: ids).order('id desc').first#order('RANDOM()').first
          else
            @idcard = Idcard.order('RANDOM()').first
          end
          
          if @idcard.blank?
            return render_error(4004, '无数据')
          end
          
          if flag == 1
            ids << @idcard.card_no
            $redis.set 'queued', ids.join(',')
          end
          
          if params[:cl] && params[:cl] == 1
            $redis.del 'queued'
          end
          
          # { code: 0, message: 'ok', data: {
#             name: @idcard.name,
#             idcard: @idcard.card_no
#           } }
          {
            id: @idcard.card_no,
            name: @idcard.name
          }
        end # end get idcard
        
        desc "获取一条昵称"
        get :nickname do
          @user_nickname = UserNickname.order('RANDOM()').first
          if @user_nickname.blank?
            return render_error(4004, '无数据')
          end
          { code: 0, message: 'ok', data: {
            nickname: @user_nickname.nickname
          } }
        end #end get nickname
        
        desc "获取一条评论或聊天内容"
        get :mock_content do
          @content = UserChat.order('RANDOM()').first
          if @content.blank?
            return render_error(4004, '无数据')
          end
          { code: 0, message: 'ok', data: {
            content: @content.content
          } }
        end # end get mock_content
        
      end # end resource
    end
  end
end