platform :ios, '10.3'
use_frameworks!

target 'MomentosApp' do
    
    pod 'Firebase'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    
    pod 'DGActivityIndicatorView'
    pod 'SAMCache'
    pod 'VENTokenField'
    
    pod 'JSQMessagesViewController'
    
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    
    pod 'lottie-ios','1.5.1'
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end

