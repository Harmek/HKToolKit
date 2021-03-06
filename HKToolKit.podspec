Pod::Spec.new do |s|
  s.name         = "HKToolKit"
  s.version      = "0.1.0"
  s.summary      = "HKToolKit is a collection of elegant class extensions and helpers for UIKit and Foundation."
  s.description  = <<-DESC
                    HKToolKit is a collection of elegant class extensions and helpers for UIKit and Foundation.
                    
                    HKTargetActionBlock contains extensions for:

                    * UIActionSheet
                    * UIAlertView
                    * UIControls
                   DESC
  s.homepage     = "http://example.com"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Panos Baroudjian" => "baroudjian.panos@gmail.com" }
  s.source       = { :git => ".", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.social_media_url = 'https://twitter.com/justPanos'
  s.frameworks = 'UIKit'

  s.subspec 'UIActionSheet' do |actionSheet|
    actionSheet.source_files = 'Classes/ios/UIActionSheet+HKToolKit.{h,m}'
  end
  s.subspec 'UIAlertView' do |alertView|
    alertView.source_files = 'Classes/ios/UIAlertView+HKToolKit.{h,m}'
  end
  s.subspec 'UIControl' do |control|
    control.source_files = 'Classes/ios/UIControl+HKToolKit.{h,m}'
  end
  s.subspec 'CGGeometry' do |geometry|
    geometry.source_files = 'Classes/HKCGPoint.{h,c}', 'Classes/HKLine.{h,c}'
  end
  s.subspec 'CGGeometryOperators' do |geometryOp|
    geometryOp.source_files = 'Classes/HKCGPointOperators.{h,cpp}'
  end
  s.subspec 'HKPropertyListViewController' do |propertyList|
    propertyList.source_files = 'Classes/ios/HKLabelCell.{h,m}', 'Classes/ios/HKNumericCell.{h,m}', 'Classes/ios/HKTextFieldCell.{h,m}', 'Classes/ios/HKSwitchCell.{h,m}', 'Classes/ios/HKPropertyListViewController.{h,m}', 'Classes/ios/HKPropertyListViewController_Protected.h', 'Classes/ios/HKTableViewHeaderFooterCellView.{h,m}'
  end
  s.subspec 'HKModules' do |modules|
    modules.source_files = 'Classes/ios/HKRoutePattern.{h,m}', 'Classes/ios/HKModuleManager.{h,m}', 'Classes/ios/HKModule.{h,m}'
  end
  s.subspec 'HKSideView' do |modules|
    modules.source_files = 'Classes/ios/HKSideView/*.{h,m}'
  end
end
