# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'XMPPWechat' do
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
  use_frameworks!
  pod 'XMPPFramework'
  # Pods for XMPPWechat

  target 'XMPPWechatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'XMPPWechatUITests' do
    # Pods for testing
  end

end
