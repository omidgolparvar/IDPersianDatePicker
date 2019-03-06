Pod::Spec.new do |s|
  s.name                  = 'PersianDatePicker'
  s.version               = '1.0.0'
  s.summary               = 'Framework for selecting date in Persian Calendar written Swift.'
  s.description           = <<-DESC
			    Framework for selecting date in Persian Calendar.
                            Written in Swift.
                            DESC
  s.homepage              = 'https://github.com/omidgolparvar/PersianDatePicker'
  s.license               = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author                = { 'Omid Golparvar' => 'iGolparvar@gmail.com' }
  s.source                = { :git => "https://github.com/omidgolparvar/PersianDatePicker.git", :tag => s.version.to_s }
  s.swift_version         = '4.2'
  s.platform              = :ios, '10.0'
  s.requires_arc          = true
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '4.2' }

  s.source_files = [
    'PersianDatePicker/Source/**/*.{h,swift}',
    'PersianDatePicker/Source/**/*.xib',
  ]
  s.resources = [
    'PersianDatePicker/Source/Assets.xcassets',
  ]
  
  s.public_header_files = 'PersianDatePicker/*.h'

  s.libraries  = "z"
  
end
