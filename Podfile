platform :ios, '9.0'

target 'AsthmaHealth' do
  pod 'TPKeyboardAvoiding', '~> 1.2'
  if ENV['CMHEALTH_DEVELOPMENT_POD_PATH']
    pod 'CMHealth', :path => ENV['CMHEALTH_DEVELOPMENT_POD_PATH']
  else
    pod 'CMHealth', :git => 'git@github.com:cloudmine/CMHealthSDK.git', :tag => '0.1.6'
    #pod 'CMHealth', :git => 'git@github.com:geoffrey-young/CMHealthSDK.git', :branch => 'add_assets_to_sdk_v1'
  end
end

target 'AsthmaHealthTests' do
end
