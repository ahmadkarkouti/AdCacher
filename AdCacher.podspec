Pod::Spec.new do |spec|
  spec.name         = 'AdCacher'
  spec.version      = '1.0.1' # Update as needed
  spec.summary      = 'A caching utility for Google Mobile Ads.'
  spec.description  = <<-DESC
    AdCacher provides an easy way to manage and cache Google Mobile Ads.
    It handles loading and caching of ads in the background for a better user experience.
  DESC
  spec.homepage     = 'https://github.com/ahmadkarkouti/AdCacher.git' # Replace with your repo URL
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Ahmad Karkouti' => 'karkouti@google.com' }
  spec.source       = { :git => 'https://github.com/ahmadkarkouti/AdCacher.git', :tag => spec.version.to_s }
  spec.platform     = :ios, '11.0'
  spec.swift_version = '5.0'

  # This specifies that AdCacher depends on Google-Mobile-Ads-SDK
  spec.dependency 'Google-Mobile-Ads-SDK'
  
  # Declare that this pod should be treated as a static framework
  spec.static_framework = true

  # Specify which files should be included in the library.
  spec.source_files  = 'AdCacher/**/*.swift'

  # If your library includes any resource bundles, add them here.
  # spec.resource_bundles = {
  #   'AdCacher' => ['AdCacher/Assets/**/*']
  # }

  # If you need to include non-code resources (like images), add them here.
  # spec.resources = ['AdCacher/Assets/**/*']

  # For any specific framework or libraries required by your code
  spec.frameworks = 'UIKit'
end

