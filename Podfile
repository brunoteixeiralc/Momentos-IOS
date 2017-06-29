platform :ios, '8.0'
use_frameworks!

target 'Momentos' do

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

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
