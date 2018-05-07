class HomeController < ApplicationController
  def error_404
    render text: 'Not found', status: 404, layout: false
  end
  
  def install
    
  end
  
  def app_start
    @urls = SiteConfig.test_app_launch_urls.split('|')
  end
  
end