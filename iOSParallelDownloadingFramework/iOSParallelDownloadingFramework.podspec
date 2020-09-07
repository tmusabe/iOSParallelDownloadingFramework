Pod::Spec.new do |s|

  s.name         = "iOSParallelDownloadingFramework"
  s.version      = "1.0.0"
  s.summary      = "iOSParallelDownloadingFramework for downloading any items parallel"
  s.description  = "It is a framework for providing a method that takes array of URLs and downloads content from those URLs asynchronously"

  s.homepage     = "https://github.com/tmusabe/iOSParallelDownloadingFramework"
  s.license      = "MIT"
  s.author       = { "Taif Al Musabe" => "taif0taif@gmail.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/tmusabe/iOSParallelDownloadingFramework.git", :tag => "1.0.0" }
  s.source_files  = "iOSParallelDownloadingFramework/**/*.{swift}"
  s.exclude_files = "iOSParallelDownloadingFramework/iOSParallelDownloadingFramework/*.plist"

end
