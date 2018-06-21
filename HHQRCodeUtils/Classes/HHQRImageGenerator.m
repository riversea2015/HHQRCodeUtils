//
//  HHQRImageGenerator.m
//  Demo_All
//
//  Created by hehai on 26/07/2017.
//  Copyright © 2017 hehai. All rights reserved.
//

#import "HHQRImageGenerator.h"

@implementation HHQRImageGenerator

#pragma mark - ************************************** 识别二维码 *************************************

+ (NSString *)detectQRImage:(UIImage *)qrImage {
    
    NSString *detectedStr = nil;
    
    if(qrImage && [qrImage isKindOfClass:[UIImage class]]) {
        
        // 1.初始化扫描仪，设置设别类型和识别质量
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                  context:nil
                                                  options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        
        // 2.扫描获取的特征组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:qrImage.CGImage]];
        
        if (features.count > 0) {
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            detectedStr = feature.messageString;
        }
    }
    
    return detectedStr;
}

#pragma mark - ************************************ 生成基础二维码 ***********************************

+ (UIImage *)generateQRImgWithContents:(NSString *)strContent size:(CGSize)qrSize {
    
    /*********************************** 1.生成初始二维码(使用CIFilter) *******************************/
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[strContent dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImg = filter.outputImage;
    
    /*********************************** 2.改变二维码颜色(前景色/背景色) *******************************/
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"]; // 前景色
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"]; // 背景色
    ciImg = colorFilter.outputImage;
    
    UIImage *qrImg = [self resizeCodeImage:ciImg size:qrSize];
    
    return qrImg;
}

/// 缩放生成的QRCode
+ (UIImage *)resizeCodeImage:(CIImage *)image size:(CGSize)size {
    
    if (image) {
        
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        
        return [UIImage imageWithCGImage:imageRefResized];
    } else {
        return nil;
    }
}

#pragma mark - ************************************ 合成二维码(一) ***********************************

+ (UIImage *)createQRImageWithContents:(NSString *)strContent
                                qrSize:(CGSize)qrSize
                               bgImage:(UIImage *)bgImage
                                bgSize:(CGSize)bgSize
                             logoImage:(UIImage *)logoImage
                              logoSize:(CGSize)logoSize
{
    if (CGSizeEqualToSize(bgSize, CGSizeZero)) {
        bgSize = qrSize;
    }
    
    CGFloat margin = (bgSize.width - qrSize.width) * 0.5;
    CGFloat logoX = (bgSize.width - logoSize.width) * 0.5;
    CGFloat logoY = (bgSize.height - logoSize.height) * 0.5;
    
    /*********************************** 1.生成初始二维码(使用CIFilter) *******************************/
    
    UIImage *qrImg = [self generateQRImgWithContents:strContent size:qrSize];
    
    /************************************ 2.为二维码添加：背景、Logo **********************************/
    
    UIGraphicsBeginImageContext(bgSize);
    
    if (bgImage && [bgImage isKindOfClass:[UIImage class]]) {
        [bgImage drawInRect:CGRectMake(0, 0, bgSize.width, bgSize.height)];
    } else {
        UIImage *whiteBg = [self imageWithColor:[UIColor whiteColor] size:bgSize];
        [whiteBg drawInRect:CGRectMake(0, 0, bgSize.width, bgSize.height)];
    }
    
    [qrImg drawInRect:CGRectMake(margin, margin, qrSize.width, qrSize.height)];
    
    if (logoImage && [logoImage isKindOfClass:[UIImage class]]) {
        UIImage *whiteImg = [self imageWithColor:[UIColor whiteColor] size:logoSize];
        [whiteImg drawInRect:CGRectMake(logoX, logoY, logoSize.width, logoSize.height)];
        [logoImage drawInRect:CGRectMake(logoX, logoY, logoSize.width, logoSize.height)];
    }
    
    UIImage *rectQRImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return rectQRImage;
}

/// 绘制纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - ************************************ 合成二维码(二) ***********************************

+ (UIImage *)createQRImgWithContents:(NSString *)strContent
                              qrSize:(CGSize)qrSize
                             bgImage:(UIImage *)bgImage
                              bgSize:(CGSize)bgSize
                           logoImage:(UIImage *)logoImage
                            logoSize:(CGSize)logoSize
                          logoRadius:(CGFloat)logoRadius
{
    /*********************************** 1.生成初始二维码(使用CIFilter) *******************************/
    
    UIImage *qrImg = [self generateQRImgWithContents:strContent size:qrSize];
    
    /********************************** 2.为二维码添加：背景、Logo、圆角 *******************************/
    
    UIImage *resultImg = [self newImageWithQRImg:qrImg
                                          qrSize:qrSize
                                          bgSize:bgSize
                                       logoImage:logoImage
                                        logoSize:logoSize
                                      logoRadius:logoRadius];
    return resultImg;
}

#pragma mark - 截屏

+ (UIImage *)newImageWithQRImg:(UIImage *)qrImg
                        qrSize:(CGSize)qrSize
                        bgSize:(CGSize)bgSize
                     logoImage:(UIImage *)logoImage
                      logoSize:(CGSize)logoSize
                    logoRadius:(CGFloat)logoRadius
{
    if (CGSizeEqualToSize(bgSize, CGSizeZero)) {
        bgSize = qrSize;
    }
    
    CGFloat margin = (bgSize.width - qrSize.width) * 0.5;
    CGFloat marginLogo = (bgSize.width - logoSize.width) * 0.5;
    
    UIView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(-bgSize.width, 0, bgSize.width, bgSize.height)];
    mainView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:qrImg];
    imgV.frame = CGRectMake(margin, margin, qrSize.width, qrSize.height);
    [mainView addSubview:imgV];
    
    UIView *logoBgV = [[UIView alloc] initWithFrame:CGRectMake(marginLogo-5, marginLogo-5, logoSize.width+10, logoSize.height+10)];
    logoBgV.backgroundColor = [UIColor whiteColor];
    logoBgV.layer.cornerRadius = logoRadius;
    logoBgV.layer.masksToBounds = YES;
    [mainView addSubview:logoBgV];
    
    UIImageView *logoV = [[UIImageView alloc] initWithImage:logoImage];
    logoV.frame = CGRectMake(marginLogo, marginLogo, logoSize.width, logoSize.height);
    logoV.layer.cornerRadius = logoRadius;
    logoV.layer.masksToBounds = YES;
    [mainView addSubview:logoV];
    
    UIImage *image = [self captureView:mainView];
    
    return image;
}

/// screenshot
+ (UIImage *)captureView:(UIView *)originView
{
    // 如果 originView 是 view（继承自UIView而非UIScrollView）
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(originView.frame.size, NO, 0.0);
    {
        CGRect savedFrame = originView.frame;
        originView.frame = CGRectMake(0, 0, originView.frame.size.width, originView.frame.size.height);
        
        [originView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        originView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    return nil;
}

@end
