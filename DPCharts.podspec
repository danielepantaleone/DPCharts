Pod::Spec.new do |s|
  s.name                  = "DPCharts"
  s.version               = "1.1.2"
  s.summary               = "A lightweight framework to render charts on iOS written in Swift"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.homepage              = "https://github.com/danielepantaleone/DPCharts"
  s.authors               = { "Daniele Pantaleone" => "danielepantaleone@me.com" }
  s.ios.deployment_target = "12.0"
  s.source                = { :git => "https://github.com/danielepantaleone/DPCharts.git", :tag => "#{s.version}" }
  s.source_files          = "Sources/DPCharts/**/*.swift"
  s.swift_version         = "5.7"
end
