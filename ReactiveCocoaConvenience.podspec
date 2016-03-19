Pod::Spec.new do |spec|
  spec.name         = 'ReactiveCococaConvenience'
  spec.version      = '0.1'
  spec.license      = { :type => 'MIT' }
  spec.authors      = { 'Josh Campion' => 'joshcampion89@gmail.com' }
  spec.summary      = 'Convenience functions and properties to develop faster with ReactiveCocoa.'
  spec.source       = { :git => 'https://bitbucket.org/joshcampion89/reactivecocoaconvenience.git', :tag => spec.version }

  spec.subspec 'Core' do |core|
    cs.dependency 'ReactiveCocoa', '~> 4.0'
    cs.source_files = 'ReactiveCocoaConvenience/**/*.swift'
  end

  spec.subspec 'Alamofire' do |ala|
    ala.dependency 'ReactiveCocoaConvenience/Core'
    ala.source_files = 'ReactiveCocoaConvenience-Alamofire/**/*.swift'
  end

  spec.subspec 'Alamofire-SwiftyJSON' do |alajson|
    alajson.dependency 'ReactiveCocoaConvenience/Core'
    alajson.source_files = 'ReactiveCocoaConvenience-Alamofire/**/*.swift'
  end

end