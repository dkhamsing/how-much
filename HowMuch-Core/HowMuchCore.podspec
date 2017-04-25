Pod::Spec.new do |s|
  s.name             = 'HowMuchCore'
  s.version          = '0.1.0'
  s.summary          = 'Core stuff for How Much app.'

  s.author           = { 'dkhamsing' => 'dkhamsing8@gmail.com' }

  s.homepage = 'https://github.com/dkhamsing'

  s.ios.deployment_target = '8.0'

  s.license = 'other'

  s.source = { :path => '.' }
  s.source_files = '*.{h,m}'

  s.requires_arc = true

  s.dependency 'DKHud', '~> 0.1'
  s.dependency 'DKAuthenticationViewController', '~> 0.2'
  s.dependency 'XLForm', '~> 3.1'
end
