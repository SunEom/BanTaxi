# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BanTaxi' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BanTaxi

	pod 'FirebaseAnalytics'
	pod 'FirebaseAuth'
	pod 'FirebaseFirestore'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'GoogleSignIn'
  pod 'SnapKit', '~> 5.6.0'
  pod 'RxAlamofire'
  pod 'DateToolsSwift'
  pod 'NVActivityIndicatorView'
  
  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                 end
            end
     end
  end
  
end
