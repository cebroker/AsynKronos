Pod::Spec.new do |spec|
  spec.name                 = "AsynKronos"
  spec.version              = "0.1.0"
  spec.summary              = "Functional async calls in swift."
  spec.description          = "Functional async calls in swift."
  spec.homepage             = "https://github.com/cebroker/AsynKronos.git"
  spec.license              = { :type => "MIT", :file => "LICENSE" }
  spec.author               = { "CE Broker" => ""}
  spec.platform             = :ios, "11.0"
  spec.source               = { :git => "https://github.com/cebroker/AsynKronos.git", :tag => "#{spec.version}" }
  spec.source_files         = "AsynKronos/**/*.{swift}"
  spec.swift_version        = "5.0"
end