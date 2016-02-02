source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
inhibit_all_warnings!

xcodeproj 'QuickBlox'

target :QuickBlox do
pod 'MagicalRecord'
pod 'PureLayout'
pod 'AFNetworking'
pod 'MBProgressHUD'
pod 'JSONModel'
pod 'WYPopoverController'
pod 'MZFormSheetController'
pod 'MBLocationManager'
pod 'GoogleMaps'
pod 'MBCalendarKit'
pod 'QuickBlox'
pod 'NMPaginator'
pod "FDKeychain"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
  end
end