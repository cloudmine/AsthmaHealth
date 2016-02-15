platform :ios, '9.0'

target 'AsthmaHealth' do
pod 'TPKeyboardAvoiding', '~> 1.2'
  if nil != ENV['CMHEALTH_DEVELOPMENT_POD_PATH'] then
    pod 'CMHealth', :path => ENV['CMHEALTH_DEVELOPMENT_POD_PATH']
  else
    pod 'CMHealth', :git => 'git@github.com:cloudmine/CMHealthSDK.git'
  end
end

target 'AsthmaHealthTests' do

end
