# require 'rest-client'
module API
  module V1
    class DatasourceAPI < Grape::API
      resource :ds, desc: '身份证信息，昵称，评论，聊天数据源接口' do
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
          
          queued = $redis.get 'queued'
          puts queued
          if flag == 1
            @idcard = Idcard.where.not(card_no: queued).order('RANDOM()').first
          else
            @idcard = Idcard.order('RANDOM()').first
          end
          
          if @idcard.blank?
            return render_error(4004, '无数据')
          end
          
          if flag == 1
            queued << @idcard.card_no
            $redis.set 'queued', queued
          end
          
          if params[:cl] && params[:cl] == 1
            $redis.del 'queued'
          end
          
          { code: 0, message: 'ok', data: {
            name: @idcard.name,
            idcard: @idcard.card_no
          } }
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