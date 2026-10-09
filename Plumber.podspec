Pod::Spec.new do |s|
  s.name             = 'Plumber'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight UIKit framework for binding data, targets, and events.'

  s.description      = <<-DESC
                        Plumber is a lightweight UIKit framework for connecting data with reusable
                        targets and handling events without exposing concrete target types.
                        It keeps data and target relationships strongly typed while allowing 
                        heterogeneous plumbers to be managed together.
                       DESC

  s.homepage         = 'https://github.com/plguyim/Plumber'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Plumber'
  s.source           = { :git => 'https://github.com/plguyim/Plumber.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'
  
end
