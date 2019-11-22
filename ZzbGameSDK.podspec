#
# Be sure to run `pod lib lint ZzbGameSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZzbGameSDK'
  s.version          = '0.1.0'
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
  s.source           = { :git => 'https://github.com/guixingyu/ZzbGameSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZzbGameSDK/Classes/**/*'
  
  #s.resource_bundles = {
  #'ZzbGameSDK' => ['ZzbGameSDK/Assets/*.png']
  #}
  
  #第三方非开源framework
  s.vendored_frameworks = [
    'ZzbGameSDK/webappexts/iphoneos/webappexts.framework',
    'ZzbGameSDK/extensions/fat/extensions.framework'
  ]
  
  s.public_header_files = 'ZzbGameSDK/Classes/**/*.h'
  s.frameworks = 'UIKit','Foundation','GLKit','VideoToolbox'
  s.libraries = 'xml2','c++'
  s.dependency 'ZBarSDK', '~> 1.3.1'
  s.dependency 'Reachability', '~> 3.0.0'
  s.dependency 'YYImage', '~> 1.0.0'
  s.dependency 'YBImageBrowser', '~> 3.0.0'
  s.dependency 'SDWebImage', '~> 5.0.0'
  s.dependency 'SocketRocket', '~> 0.5.0'
end
