Pod::Spec.new do |s|
  s.name             = 'GiniPayBank'
  s.version          = '0.0.1'
  s.summary          = 'Computer Vision Library for scanning documents.'

  s.description      = <<-DESC
Gini provides an information extraction system for analyzing documents (e. g. invoices or
contracts), specifically information such as the document sender or the amount to pay in an invoice.

The Gini Pay Bank SDK for iOS provides functionality to capture documents with mobile phones.
                       DESC

  s.homepage         = 'https://www.gini.net/en/developer/'
  s.license          = { :type => 'Private', :file => 'LICENSE' }
  s.author           = { 'Gini GmbH' => 'hello@gini.net' }
  s.frameworks       = 'AVFoundation', 'CoreMotion', 'Photos'
  s.source           = { :git => 'git@github.com:gini/gini-pay-bank-sdk-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gini'
  s.swift_version    = '5.0'
  s.ios.deployment_target = '10.0'
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'GiniPayBank/Classes/Core/**/*'
    core.resources = 'GiniPayBank/Assets/*'
  end

  s.subspec 'Networking' do |networking|
    networking.source_files = 'GiniPayBank/Classes/Networking/*.swift', 'GiniPayBank/Classes/Networking/Extensions/*.swift'
    networking.dependency "GiniCapture/Core"
    networking.dependency 'GiniPayApiLib/DocumentsAPI', '>= 1.0.2'
  end

  s.subspec 'Networking+Pinning' do |pinning|
    pinning.source_files = 'GiniPayBank/Classes/Networking/Pinning/*'
    pinning.dependency "GiniCapture/Networking"
    pinning.dependency 'GiniPayApiLib/Pinning', '>= 1.0.2'
  end

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'GiniPayBank/Tests/*.swift'
    test_spec.resources = 'GiniPayBank/Tests/Assets/*'
    test_spec.requires_app_host = true
  end

end
