#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Shield'
  s.version          = '2.1.4'
  s.summary          = 'Shield is an iOS/macOS/tvOS framework that wraps various authorization APIs (e.g. camera, photo, location).'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Shield is an iOS/macOS/tvOS framework that wraps various authorization APIs (e.g. camera, photo, location). The majority of the wrapped APIs are for iOS, with a few cross platform available on macOS and tvOS as well. Subspecs are provided for each individual set of wrapped APIs.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/Shield'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/Shield.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  s.tvos.deployment_target = '10.0'
  
  s.requires_arc = true

  s.ios.source_files = 'Shield/*.{h,m}', 'Shield/iOS/*.{h,m}', 'Shield/Private/*.{h,m}'
  s.osx.source_files = 'Shield/*.{h,m}', 'Shield/macOS/*.{h,m}', 'Shield/Private/*.{h,m}'
  s.tvos.source_files = 'Shield/KSHLocationAuthorization.{h,m}', 'Shield/KSHPhotosAuthorization.{h,m}', 'Shield/KSHNotificationAuthorization.{h,m}', 'Shield/iOS/KSHVideoSubscriberAccountAuthorization.{h,m}', 'Shield/Private/*.{h,m}'
  s.exclude_files = 'Shield/Shield-Info.h'
  s.private_header_files = 'Shield/Private/*.h'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'Shield/Shield.h'

    ss.resource_bundles = {
      'Shield' => ['Shield/**/*.{lproj}']
    }
  end
  
  s.subspec 'Camera' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHCameraAuthorization.{h,m}'
    
    ss.frameworks = 'AVFoundation'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Microphone' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHMicrophoneAuthorization.{h,m}'
    
    ss.frameworks = 'AVFoundation'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'MediaLibrary' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHMediaLibraryAuthorization.{h,m}'
    
    ss.frameworks = 'MediaPlayer'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Health' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHHealthAuthorization.{h,m}'
    
    ss.frameworks = 'HealthKit'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Siri' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHSiriAuthorization.{h,m}'
    
    ss.frameworks = 'Intents'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Speech' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHSpeechAuthorization.{h,m}'
    
    ss.frameworks = 'Speech'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Bluetooth' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHBluetoothAuthorization.{h,m}'
    
    ss.frameworks = 'CoreBluetooth'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Home' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHHomeAuthorization.{h,m}'
    
    ss.frameworks = 'HomeKit'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Motion' do |ss|
    ss.ios.deployment_target = '12.0'
    
    ss.source_files = 'Shield/**/KSHMotionAuthorization.{h,m}'
    
    ss.frameworks = 'CoreMotion'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Photos' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.tvos.deployment_target = '10.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHPhotosAuthorization.{h,m}'
    
    ss.frameworks = 'Photos'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Notification' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.tvos.deployment_target = '10.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHNotificationAuthorization.{h,m}'
    
    ss.frameworks = 'UserNotifications'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'VideoSubscriberAccount' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.tvos.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHVideoSubscriberAccountAuthorization.{h,m}'
    
    ss.frameworks = 'VideoSubscriberAccount'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Event' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHEventAuthorization.{h,m}'
    
    ss.frameworks = 'EventKit'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Contacts' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHContactsAuthorization.{h,m}'
    
    ss.frameworks = 'Contacts'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Local' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHLocalAuthorization.{h,m}', 'Shield/Private/*.{h,m}'
    
    ss.frameworks = 'LocalAuthentication'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Location' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.osx.deployment_target = '10.14'
    ss.tvos.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHLocationAuthorization.{h,m}'
    
    ss.frameworks = 'CoreLocation'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Accessibility' do |ss|
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHAccessibilityAuthorization.{h,m}'
    
    ss.frameworks = 'ApplicationServices', 'AppKit'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
  
  s.subspec 'Security' do |ss|
    ss.osx.deployment_target = '10.14'
    
    ss.source_files = 'Shield/**/KSHSecurityAuthorization.{h,m}', 'Shield/**/KSHSecurityRights.{h,m}', 'Shield/Private/*.{h,m}'
    
    ss.frameworks = 'Security'
    
    ss.dependency 'Stanley'
    ss.dependency 'Shield/Core'
  end
end
