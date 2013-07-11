//
//  EGOImageView.h
//  EGOImageLoading
//
// 改进功能：图片加载显示不再需要释放屏幕，每次调用setImageURL:方法都会创建异步请求，然后显示图片。
// 主要使用ASIHTTPRequest代替原有的NSURLConnection，修改部分通知发送功能等；
//
// ASIHTTPRequest支持库：
// 1、CFNetwork.framework；
// 2、libxml2.dylib
// 3、libz.dylib
// 4、MobileCoreServices.framework
// 5、SystemConfiguration.framework
//
// libxml/HTMLparser.h file not found 错误解决:
// targets -> build settings -> Header search paths添加路径: /usr/include/libxml2
// 
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader.h"

@protocol EGOImageViewDelegate;
@interface EGOImageView : UIImageView<EGOImageLoaderObserver> {
@private
	NSURL* imageURL;
	UIImage* placeholderImage;
	id<EGOImageViewDelegate> delegate;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate;

- (void)cancelImageLoad;

@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,assign) id<EGOImageViewDelegate> delegate;
@end

@protocol EGOImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImage:(EGOImageView*)imageView;
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error;
@end