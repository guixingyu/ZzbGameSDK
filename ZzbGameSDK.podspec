#
# Be sure to run `pod lib lint ZzbGameSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZzbGameSDK'
  s.version          = '0.7.0'
  s.summary          = 'A short description of ZzbGameSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/guixingyu/ZzbGameSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guixingyu' => '460734287@qq.com' }
  s.source           = { :git => '/Users/yhy/Documents/GameSDK/ios/ZzbGameSDK', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = [
	'ZzbGameSDK/Classes/**/*'
  ]
  
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
  
  s.resource_bundles = {
    'ZzbGameSDK' => ['ZzbGameSDK/Assets/*.png']
  }
  
  #第三方非开源framework
  s.vendored_frameworks = [
    'ZzbGameSDK/webappexts/iphoneos/webappexts.framework',
    'ZzbGameSDK/extensions/fat/extensions.framework',
    'ZzbGameSDK/UTDID.framework'
    #'ZzbGameSDK/BUD-Frameworks/BUAdSDK.framework'
  ]
  
  s.public_header_files = [
    'ZzbGameSDK/Classes/ZzbGameManager.h'
  ]
  
  s.frameworks = 'UIKit','Foundation','GLKit','VideoToolbox','StoreKit','MobileCoreServices','WebKit','MediaPlayer','CoreMedia','AVFoundation','CoreLocation','CoreTelephony','SystemConfiguration','AdSupport','CoreMotion'
  s.libraries = 'xml2','c++','z','resolv.9'
  s.dependency 'ZBarSDK', '~> 1.3.1'
  s.dependency 'Reachability', '~> 3.0.0'
  s.dependency 'YYImage', '~> 1.0.0'
  #s.dependency 'YBImageBrowser', '~> 3.0.0'
  #s.dependency 'SDWebImage'
  s.dependency 'IDMPhotoBrowser', '~> 1.11.3'
  s.dependency 'SocketRocket', '~> 0.5.0'
  s.dependency 'LBXScan/LBXNative','~> 2.3'
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'JSONModel'
  s.dependency 'MJRefresh', '~> 3.2.2'
  s.dependency 'SDCycleScrollView','~> 1.80'
  #s.dependency 'Bytedance-UnionAD', '~> 2.5.1.5'
end
