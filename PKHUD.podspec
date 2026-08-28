Pod::Spec.new do |s|
  s.name                      = 'PKHUD'
  s.module_name               = 'PKHUD'
  s.version                   = '5.7.0'
  s.summary                   = 'A modern Swift based reimplementation of the Apple HUD for iOS 13 and up'
  s.homepage                  = 'https://github.com/Geoege-xll/PKHUD'
  s.license                   = 'MIT'
  s.author                    = { 'Philip Kluz' => 'Philip.Kluz@gmail.com' }
  s.platform                  = :ios, '13.0'
  s.ios.deployment_target     = '13.0'
  s.requires_arc              = true
  s.source                    = { :git => 'https://github.com/Geoege-xll/PKHUD.git', :tag => s.version.to_s }
  s.source_files              = 'PKHUD/**/*.{h,swift}'
  s.resource_bundle           = { 'PKHUDResources' => 'PKHUD/*.xcassets' }
  s.swift_version             = '5.0'  
end
