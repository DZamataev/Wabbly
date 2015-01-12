#
# Be sure to run `pod lib lint Wabbly.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Wabbly"
  s.version          = "1.1.1"
  s.summary          = "iOS SDK additions which you always need and they migrate from project to project. Handy categories, scripts, extensions."
  s.homepage         = "https://github.com/DZamataev/Wabbly"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Denis Zamataev" => "denis.zamataev@gmail.com" }
  s.source           = { :git => "https://github.com/DZamataev/Wabbly.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dzamataev'

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'Wabbly' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
