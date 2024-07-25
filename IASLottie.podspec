Pod::Spec.new do |s|

    s.name = 'IASLottie'
    s.version = '0.1.0'
    s.platform = :ios, '12.0'
    s.license  = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage = 'https://github.com/inappstory/ios-lottie'
    s.author = { "St.Pashik" => "stpashik@gmail.com" }
    s.source = { :git => 'https://github.com/inappstory/ios-lottie.git', :tag => s.version }
    s.summary = 'Library Connector, for connecting Lottie animations to games for InAppStorySDK'
    s.description = 'Library Connector, for connecting Lottie animations to games for InAppStorySDK'

    s.vendored_frameworks = "IASLottie.xcframework"
end
