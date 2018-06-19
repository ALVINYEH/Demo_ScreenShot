//
//  ViewController.m
//  Demo_TakeScreenShot
//
//  Created by game-netease-chuyou on 2018/6/19.
//  Copyright © 2018年 chuyou. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Photos/Photos.h"


@interface ViewController ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}



//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    NSLog(@"检测到截屏");
    
//    //人为截屏, 模拟用户截屏行为, 获取所截图片
//    UIImage *image_ = [self imageWithScreenshot];
    
    //截屏后取出相册最后一张图
    [self latestAssetImage];
    
    //截图后的需求：在右下角展示图片
   
    
}


- (void)showScreenShot:(UIImage *)image
{
    

    self.imageView = [[UIImageView alloc] initWithImage:image];
    
    //添加显示
    self.imageView.frame = CGRectMake(self.view.frame.size.width/1.3, self.view.frame.size.height/1.3, self.view.frame.size.width/4, self.view.frame.size.height/4);
    
    
    //添加边框
    //    CALayer * layer = [imageView layer];
    //    layer.borderColor = [[UIColor whiteColor] CGColor];
    //    layer.borderWidth = 5.0f;
    //添加四个边阴影
    
    //    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    //    imgvPhoto.layer.shadowOpacity = 0.5;
    //    imgvPhoto.layer.shadowRadius = 10.0;
    //    //添加两个边阴影
    //    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
    //    imgvPhoto.layer.shadowOpacity = 0.5;
    //    imgvPhoto.layer.shadowRadius = 2.0;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.imageView.bounds];
    self.imageView.layer.masksToBounds = NO;
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.imageView.layer.shadowOpacity = 0.5f;
    self.imageView.layer.shadowRadius = 10.0;
    self.imageView.layer.shadowPath = shadowPath.CGPath;
    
    [self.view addSubview:self.imageView];
}


//模拟用户截屏
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

//处理截图的图片 转化为png再展示
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}


- (void)screenshotWithView:(UIView *)view
{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    
    ////  自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates: 它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}

//获取相册最新的一张图片
- (void)latestAssetImage
{
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creaetionDate" ascending:NO]];
//    PHFetchResult *assetFetchResults = [PHAsset fetchAssetsWithOptions:options];
//    PHAsset *asset = [assetFetchResults firstObject];
//
//    PHImageManager *imageManager = [[PHImageManager alloc] init];
//    [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * result, NSDictionary * info) {
//        if (result) {
//            [self showScreenShot:result];
//        }
//    }];
//}
    
   
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    // 在资源的集合中获取第一个集合，并获取其中的图片
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    //PHAsset *asset = assetsFetchResults[0];
//    PHAsset *asset = [assetsFetchResults firstObject];

    PHAsset *asset = assetsFetchResults[0];
     NSLog(@"asset = %@",asset);
    //设定显示照片的尺寸
    CGFloat width = self.imageView.frame.size.width/4;
    CGFloat height = self.imageView.frame.size.height/4;
    CGSize imageSize = CGSizeMake(width, height);
    
    [imageManager requestImageForAsset:asset
                            targetSize:imageSize
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                             NSLog(@"imageResult = %@",result);
                             // 得到一张 UIImage，展示到界面上
                             [self showScreenShot:result];
                             
                         }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
