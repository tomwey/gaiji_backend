# require 'rest-client'
module API
  module V1
    class DatasourceAPI < Grape::API
      resource :ds, desc: '身份证信息，昵称，评论，聊天数据源接口' do
        desc "获取一条身份证信息"
        get :idcard do
          @idcard = Idcard.order('RANDOM()').first
          if @idcard.blank?
            return render_error(4004, '无数据')
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