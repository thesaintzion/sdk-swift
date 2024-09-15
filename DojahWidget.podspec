Pod::Spec.new do |s|
  s.name         = 'DojahWidget'
  s.version      = '1.0.0'
  s.summary      = 'DojahWidget for react native.'
  s.homepage     = 'https://github.com/shittu33/DojahWidget'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Your Name' => 'your.email@example.com' }
  s.source       = { :git => 'https://github.com/shittu33/DojahWidget.git', :tag => s.version }

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*.{swift,h}'
  s.resource_bundles = {
   'Resources' => ['Sources/DojahWidget/Resources/**/*']
  }

  # Include all JSON and Animation files from resources
  s.resources = [
    'Resources/JSON/countries.json',
    'Resources/JSON/government_data_config.json',
    'Resources/JSON/free_email_domains.json',
    'Resources/JSON/disposable_email_domains.json',
    'Resources/JSON/pricing_config.json',
    'Resources/Animations/loading-circle.json',
    'Resources/Animations/cancel.json',
    'Resources/Animations/warning.json',
    'Resources/Animations/error-2.json',
    'Resources/Animations/failed.json',
    'Resources/Animations/check-2.json',
    'Resources/Animations/success.json',
    'Resources/Animations/successfully-done.json',
    'Resources/Animations/error.json',
    'Resources/Animations/circle-loader.json',
    'Resources/Animations/successfully-done-2.json',
    'Resources/Animations/successfully-send.json',
    'Resources/Animations/check_1.json'
  ]

  # External dependencies equivalent to those in the Package.swift
  s.dependency 'HorizonCalendar', '~> 1.0.0'
  s.dependency 'lottie-ios', '~> 4.3.3'
  s.dependency 'RealmSwift', '~> 10.52.2'
  s.dependency 'IQKeyboardManagerSwift', '~> 7.1.1'
  s.dependency 'Kingfisher', '~> 7.6.1'
  s.dependency 'GooglePlaces', '~> 8.3.0'

  # Alternatively, for pre-built frameworks:
  # s.vendored_frameworks = 'Frameworks/*.xcframework'
end

