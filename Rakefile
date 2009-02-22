require "rubygems"
require "rake"

require "choctop"

ChocTop.new do |s|
  # Remote upload target
  s.host     = 'davenport.com'
  s.base_url   = "http://#{s.host}"
  s.remote_dir = '/path/to/upload/root/of/app'

  # Custom DMG
  s.background_file = "Images/installer-background.jpg"
  s.app_icon_position = [100, 170]
  s.applications_icon_position =  [400, 170]
  #s.volume_icon = "dmg.icns"
  #s.applications_icon = "Images/divan-4.icns" # or "appicon.png"
end
