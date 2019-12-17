Pod::Spec.new do |s|
  s.name = "ZzbGameSDK"
  s.version = "0.8.0"
  s.summary = "A short description of ZzbGameSDK."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"guixingyu"=>"460734287@qq.com"}
  s.homepage = "https://github.com/guixingyu/ZzbGameSDK"
  s.description = "TODO: Add long description of the pod here."
  s.frameworks = ["UIKit", "Foundation", "GLKit", "VideoToolbox", "StoreKit", "MobileCoreServices", "WebKit", "MediaPlayer", "CoreMedia", "AVFoundation", "CoreLocation", "CoreTelephony", "SystemConfiguration", "AdSupport", "CoreMotion"]
  s.libraries = ["xml2", "c++", "z", "resolv.9"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/ZzbGameSDK.embeddedframework/ZzbGameSDK.framework'
end
