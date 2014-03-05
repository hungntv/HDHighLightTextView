Pod::Spec.new do |s|
  s.name         = "HDHighLightTextView"
  s.version      = "0.0.1"
  s.summary      = "An test library of HDSoft."
  s.description  = <<-DESC
                    An test library of HDSoft.
                   DESC
  s.homepage     = "http://www.google.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Viet Hung' => 'di_timtriky@yahoo.com' }
  s.source       = { :git => "https://bitbucket.org/hdentertainment/appmerger.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = 'HDHighLightTextView/*.{h,m}'
  s.platform     = :ios, '5.0'
#  s.framework    = "CoreGraphics"
  s.requires_arc = true
end
