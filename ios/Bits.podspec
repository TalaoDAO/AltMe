Pod::Spec.new do |s|
  s.name         = "Bits"
  s.version      = "2.0.4"
  s.summary      = "A Swift library for working with raw bits and bytes in a byte buffer."
  s.description  = "Bits allows for packing and unpacking of both bytes and bits in relation to an array of bytes of arbitrary length."
  s.homepage     = "https://github.com/OperatorFoundation/Bits"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Operator Foundation" => "contact@operatorfoundation.org" }
  s.platforms    = { :ios => "13.0" }
  s.source       = { :git => "https://github.com/OperatorFoundation/Bits.git", :tag => "2.0.4" }
  s.source_files = "Sources/Bits/**/*.{swift}"
  s.swift_version = "5.0"
  s.dependency "Datable", "~> 4.0.1"
end
