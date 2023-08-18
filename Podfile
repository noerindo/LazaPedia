# Uncomment the next line to define a global platform for your project
 platform :ios, '16.0'

target 'LoginLearning' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LoginLearning
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'Alamofire'
pod 'Swifter', :git => "https://github.com/mattdonnelly/Swifter.git"
pod 'GoogleSignIn'
pod 'SDWebImage'
pod 'SideMenu'
pod "CreditCardForm"
pod 'Stripe'
pod 'SnackBar.swift'
pod 'DPOTPView'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
