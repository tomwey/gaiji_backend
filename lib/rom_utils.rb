class ROMUtils
  def self.create_serial
    return SecureRandom.hex(6).upcase
  end
  
  def self.create_android_id
    return SecureRandom.hex(8)
  end
  
  def self.create_imei
    prefix = %w(35 86).sample
    digits14 = prefix + 12.times.map{rand(10)}.join
    
    # 生成校验位
    digit15 = 0
    14.times do |n|
      if n % 2 == 0
        digit15 = digit15 + digits14[n].to_i
      else
        digit15 = digit15 + (digits14[n].to_i * 2) % 10 + (digits14[n].to_i * 2) / 10
      end
    end
    digit15 = digit15 % 10
    
    return digits14 + digit15.to_s
  end
  
  def self.create_sim_serial
    return SecureRandom.hex(10)
  end
  
  def self.create_sim_serial_for(carrier_id)
    if carrier_id == '46000' || carrier_id == '46002'
      prefix = '898600'
    elsif carrier_id == '46001'
      prefix = '898601'
    elsif carrier_id == '46003'
      prefix = '898603'
    else
      prefix = '898600'
    end
    
    return prefix + rand.to_s[2..8] + rand.to_s[2..8]
  end
  
  def self.create_imsi_for(carrier_id)
    return carrier_id + rand.to_s[2..6] + rand.to_s[2..6]
  end
  
  def self.create_sim_country
    return "cn"
  end
  
  # 生成随机姓名
  def self.create_chinese_name
    first_words = %w(赵 钱 孙 李 周 吴 郑 王 冯 陈 褚 卫 蒋 沈 韩 杨 朱 秦 尤 许 何 吕 施 张 孔 曹 严 华 金 魏 陶  姜 戚 谢 邹)
    name_words = %w(哥 总 方舟 国庆 国强 姐 老弟 老兄 掌柜 小伟 小姐 二娃 老表 舅子 姑妈 兄 老板 姑父 老师 律师 勇 嫂子 川 小明)
    return "#{first_words[rand(0...first_words.length)]}#{name_words[rand(0...name_words.length)]}"
  end
  
  def self.create_tel_number
    tel_prefix = %w(130 131 132 133 134 135 136 137 138 139 150 151 152 153 155 156 157 158 159 177 180 181 182 183 187 189)
    tel = tel_prefix[rand(0...tel_prefix.length)].to_s + rand.to_s[2..9]
    # puts tel
    return tel
  end
  
  def self.create_tel_number_for(carrier_id)
    zgyd = %w(134 135 136 137 138 139 150 151 152 157 158 159 182 183 187 188)
    zglt = %w(130 131 132 155 156 185 186)
    zgdx = %w(133 153 173 177 180 181 189)
    
    tel_prefix = if carrier_id == '46000' || carrier_id == '46002'
      zgyd.sample
    elsif carrier_id == '46001'
      zglt.sample
    elsif carrier_id == '46003'
      zgdx.sample
    else
      ''
    end
    
    if tel_prefix.blank?
      return ''
    else
      return tel_prefix + rand.to_s[2..9]
    end
  end
  
  def self.create_carrier_id
    ids = %w(46000 46001 46002 46003)
    return ids[rand(0...ids.length)]
  end
  
  def self.create_carrier_name_for(carrier_id)
    if carrier_id == '46000' || carrier_id == '46002'
      return '中国移动'
    elsif carrier_id == '46001'
      return '中国联通'
    elsif carrier_id == '46003'
      return '中国电信'
    else
      return nil
    end
  end
  
  def self.create_local_ip
    prefix = ['192.168', '10.1', '10.19'].sample
    suffix = ".%d.%d" % [rand(0...100), rand(2...255)]
    return prefix + suffix
  end
  
  def self.create_network_type
    return rand(0...15).to_s
  end
  
  def self.create_phone_type
    return rand(0..2).to_s
  end
  
  def self.create_sim_state
    return '1'#rand(0...5).to_s
  end
  
  def self.create_mac_addr
    return 6.times.map { '%02x' % rand(0..255) }.join(':')
  end
  
  def self.create_bluetooth_mac
    return ROMUtils.create_mac_addr
  end
  
  def self.create_wifi_mac
    return ROMUtils.create_mac_addr
  end
  
  def self.create_wifi_name
    type_1_prefix = %w(TP-Link_ Tenda_ MERCURY_ ChinaNet_)
    type_2_words = %w(rjxcg 最好的 loving 很不错哦 别偷网 relax-ChinaNet- closet danger peephole digital happy918 sunny cover waiter starbucks captialmall zjnb sfdc perfume-lean Levic VeryDD hencuocou useful-shower roast)
    n = rand(20)
    if n > 12
      return type_2_words.sample
    else
      type_1_prefix.sample + SecureRandom.hex(3)
    end
    # return SecureRandom.hex(5)
  end
  
  def self.create_os_info
    # info = [
    #   "3.2,13"  , "4.0.0,14", "3.2,13",
    #   "4.0.0,14", "4.0.1,14", "4.0.2,14",
    #   "4.0.3,15", "4.0.4,15", "4.1.1,16",
    #   "4.1,16"  , "4.2,17"  , "4.2.1,17",
    #   "4.2.2,17", "4.3,18"  , "4.4.4,19",
    #   "4.4,19"  , "4.4w,20" , "5.0,21",
    #   "5.2,22"  , "6.0,23"  , "7.0,24",
    #   "7.1.1,25", "8.0,26"
    # ]
    
    info = [
      "5.0,21", "5.0.1,21","5.1,22","5.1.1,22",
      "6.0,23","6.0.1,23",
      # "7.0,24","7.1.1,25","7.1.2,25"
    ]
    
    return info[rand(0...info.length)]
    
  end
  
  def self.create_screen_size
    screen_data = [
      "480*640", "240*400", "320*533", 
      "600*800", "480*800", "480*854", 
      "1080*1920","540*960", "720*1280",
    	"1080*1800"
    ]
	
    dpi_data = [
      "200", "120", "160", 
      "210", "240", "240", 
      "480", "300", "320",
      "480"
    ]
    
    index = rand(0...screen_data.length)
    return screen_data[index],dpi_data[index]
  end
  
end