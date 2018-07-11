Pod::Spec.new do |s|
          #1.
          s.name               = "Gamification"
          #2.
          s.version            = "1.0.0"
          #3.  
          s.summary         = "Gamification sdk to manage the point and actions in your native ios app."
          #4.
          s.homepage        = "https://github.com/zeeshaneureka93/GamificationSwift"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "Zeeshan"
          #7.
          s.platform            = :ios, "10.0"
          #8.
          s.source              = { :git => "https://github.com/zeeshaneureka93/GamificationSwift.git", :tag => "1.0.0" }
          #9.
          s.source_files     = "Gamification", "Gamification/**/*.{h,m,swift}"
	s.dependency 'Alamofire'
    end