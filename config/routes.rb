Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # 富文本上传路由
  mount RedactorRails::Engine => '/redactor_rails'
  
  get 'install' => 'home#install'
  
  get 'app/start' => 'home#app_start'
  post 'awake_tasks/:task_id/upload_log' => 'home#upload_awake_task_log'
  
  get 'util/mobile' => 'home#get_mobile'
  
  # /task/url?id=484848844
  get 'task/url'    => 'home#get_task_url'
  post 'task/upload_log' => 'home#upload_task_log'
  
  # /export.csv?date=2018-05-06&url=http://394949944.com
  get '/export' => 'home#export_csv'
  
  # 网页文档
  resources :pages, path: :p, only: [:show]
  
  # 队列后台管理
  require 'sidekiq/web'
  authenticate :admin_user do
    mount Sidekiq::Web => 'sidekiq'
  end
  
  # # API 文档
  mount GrapeSwaggerRails::Engine => '/apidoc'
  # #
  # # API 路由
  mount API::Dispatch => '/api'
  
  match '*path', to: 'home#error_404', via: :all
end
