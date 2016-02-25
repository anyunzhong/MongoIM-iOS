
Pod::Spec.new do |s|


  s.name         = "MongoIM"
  s.version      = "1.0.0"
  s.summary      = "IM 即时通讯 聊天 单聊 讨论组 微信风格"

  s.homepage     = "https://github.com/anyunzhong/MongoIM"

  s.license      = "Apache 2.0"

  s.author       = { "AllenZhong" => "2642754767@qq.com" }

  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/anyunzhong/MongoIM.git", :tag => "1.0.0" }


  s.source_files = "MongoIM/MongoIM/**/*.{h,m}"

  s.resources = "MongoIM/MongoIM/Resource/*.png"


  s.requires_arc = true

  s.dependency 'DFCommon', '~> 1.3.7'
  s.dependency 'AFNetworking', '~> 2.6.0'
  s.dependency 'SDWebImage', '~> 3.7.3'
  s.dependency 'FMDB', '~> 2.5'
  s.dependency 'MBProgressHUD', '~> 0.9.1'
  s.dependency 'MLLabel', '~> 1.7'

  s.dependency 'MJRefresh', '~> 2.4.11'
  s.dependency 'ODRefreshControl', '~> 1.2'
  s.dependency 'MJPhotoBrowser', '~> 1.0.2'
  s.dependency 'MMPopupView'
  s.dependency 'TZImagePickerController'
  s.dependency 'FLAnimatedImage', '~> 1.0.10'
  s.dependency 'RongCloudIMLib', '~> 2.4.5'
  s.dependency 'AMap2DMap'
  s.dependency 'AMapSearch'
  s.dependency 'MWPhotoBrowser'

end
