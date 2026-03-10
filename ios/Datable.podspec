Pod::Spec.new do |s|
  s.name         = "Datable"
  s.version      = "4.0.1"
  s.summary      = "Swift convenience functions to convert between various different types and Data."
  s.description  = "Datable provides Swift convenience functions to convert between various different types and Data."
  s.homepage     = "https://github.com/OperatorFoundation/Datable"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Operator Foundation" => "contact@operatorfoundation.org" }
  s.platforms    = { :ios => "14.0" }
  s.source       = { :git => "https://github.com/OperatorFoundation/Datable.git", :tag => "4.0.1" }
  s.source_files = "Sources/Datable/**/*.{swift}"
  s.swift_version = "5.0"
end
