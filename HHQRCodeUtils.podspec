#
# Be sure to run `pod lib lint HHQRCodeUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HHQRCodeUtils'
  s.version          = '0.0.3'
  s.summary          = 'This is a QRCode tool collection.'
  s.description      = <<-DESC
This is a QRCode tool collection, include generating and detecting.
                       DESC

  s.homepage         = 'https://github.com/riversea2015/HHQRCodeUtils'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'riversea2015' => 'hehai682@126.com' }
  s.source           = { :git => 'https://github.com/riversea2015/HHQRCodeUtils.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hehai682'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HHQRCodeUtils/Classes/**/*.{h,m}'

  s.resource_bundles = {
    'HHQRCodeUtils' => ['HHQRCodeUtils/Assets/*.png']
  }

  s.public_header_files = 'HHQRCodeUtils/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation'
  # s.dependency 'AFNetworking', '~> 2.3'

end
