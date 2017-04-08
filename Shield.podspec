#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Shield'
  s.version          = '0.18.0'
  s.summary          = 'Shield is an iOS/macOS/tvOS framework that wraps various authorization APIs (e.g. camera, photo, location).'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Shield is an iOS/macOS/tvOS framework that wraps various authorization APIs (e.g. camera, photo, location). The majority of the wrapped APIs are for iOS, with a few cross platform available on macOS as well. Only the methods for location and photo library are available on tvOS.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/Shield'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/Shield.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  
  s.requires_arc = true

  s.ios.source_files = 'Shield/*.{h,m}', 'Shield/iOS/*.{h,m}'
  s.osx.source_files = 'Shield/*.{h,m}', 'Shield/macOS/*.{h,m}'
  s.tvos.source_files = 'Shield/KSHLocationAuthorization.{h,m}', 'Shield/iOS/KSHPhotosAuthorization.{h,m}'
  s.exclude_files = 'Shield/Shield-Info.h'
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }
  
  s.subspec 'Camera' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHCameraAuthorization.{h,m}'
    
    ss.frameworks = 'AVFoundation'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Microphone' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHMicrophoneAuthorization.{h,m}'
    
    ss.frameworks = 'AVFoundation'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'MediaLibrary' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHMediaLibraryAuthorization.{h,m}'
    
    ss.frameworks = 'MediaPlayer'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Health' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHHealthAuthorization.{h,m}'
    
    ss.frameworks = 'HealthKit'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Siri' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHSiriAuthorization.{h,m}'
    
    ss.frameworks = 'Intents'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Speech' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHSpeechAuthorization.{h,m}'
    
    ss.frameworks = 'Speech'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Bluetooth' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHBluetoothAuthorization.{h,m}'
    
    ss.frameworks = 'CoreBluetooth'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Home' do |ss|
    ss.ios.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHHomeAuthorization.{h,m}'
    
    ss.frameworks = 'HomeKit'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Photos' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.tvos.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHPhotosAuthorization.{h,m}'
    
    ss.frameworks = 'Photos'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Event' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.osx.deployment_target = '10.12'
    
    ss.source_files = 'Shield/**/KSHEventAuthorization.{h,m}'
    
    ss.frameworks = 'EventKit'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Contacts' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.osx.deployment_target = '10.12'
    
    ss.source_files = 'Shield/**/KSHContactsAuthorization.{h,m}'
    
    ss.frameworks = 'Contacts'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Accounts' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.osx.deployment_target = '10.12'
    
    ss.source_files = 'Shield/**/KSHAccountsAuthorization.{h,m}'
    
    ss.frameworks = 'Accounts'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Location' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.osx.deployment_target = '10.12'
    ss.tvos.deployment_target = '10.0'
    
    ss.source_files = 'Shield/**/KSHLocationAuthorization.{h,m}'
    
    ss.frameworks = 'CoreLocation'
    
    ss.dependency 'Stanley'
  end
  
  s.subspec 'Accessibility' do |ss|
    ss.osx.deployment_target = '10.12'
    
    ss.source_files = 'Shield/**/KSHAccessibilityAuthorization.{h,m}'
    
    ss.frameworks = 'ApplicationServices', 'AppKit'
    
    ss.dependency 'Stanley'
  end
end
