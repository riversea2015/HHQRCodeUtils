//
//  HHQRImageGenerator.h
//  Demo_All
//
//  Created by hehai on 26/07/2017.
//  Copyright © 2017 hehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHQRImageGenerator : NSObject

/**
 生成二维码(绘制)

 @param strContent 用于生成二维码的字符串
 @param qrSize 二维码size
 @param bgImage  背景图(非必传)
 @param bgSize   背景size
 @param logoImage logo图片(非必传)
 @param logoSize  logo的size(非必传)
 @return 生成的二维码图片
 */
+ (UIImage *)createQRImageWithContents:(NSString *)strContent
                                qrSize:(CGSize)qrSize
                               bgImage:(UIImage *)bgImage
                                bgSize:(CGSize)bgSize
                             logoImage:(UIImage *)logoImage
                              logoSize:(CGSize)logoSize;

/**
 生成二维码(截屏)
 
 * 这个可以加圆角

 @param strContent 用于生成二维码的字符串
 @param qrSize 二维码size
 @param bgImage  背景图(非必传)
 @param bgSize   背景size
 @param logoImage logo图片(非必传)
 @param logoSize  logo的size(非必传)
 @param logoRadius logo的圆角半径
 @return 生成的二维码图片
 */
+ (UIImage *)createQRImgWithContents:(NSString *)strContent
                              qrSize:(CGSize)qrSize
                             bgImage:(UIImage *)bgImage
                              bgSize:(CGSize)bgSize
                           logoImage:(UIImage *)logoImage
                            logoSize:(CGSize)logoSize
                          logoRadius:(CGFloat)logoRadius;

/**
 识别二维码

 @param qrImage 待识别的二维码图片
 @return 识别出的字符串
 */
+ (NSString *)detectQRImage:(UIImage *)qrImage;

@end
