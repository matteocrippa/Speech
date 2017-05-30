#
# Be sure to run `pod lib lint Speech.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Speech'
  s.version          = '0.1.0'
  s.summary          = 'A shared instance to easily use text to speech in iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An easy shared instance to make use of text to speech functions in iOS
                       DESC

  s.homepage         = 'https://github.com/matteocrippa/Speech'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'matteocrippa' => '@_ghego' }
  s.source           = { :git => 'https://github.com/matteocrippa/Speech.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/@_ghego'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Speech/Classes/**/*'
  
  s.frameworks = 'AVFoundation'
end
