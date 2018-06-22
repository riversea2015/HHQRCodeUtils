//
//  HHQRCodeScanVC.h
//  HHQRCodeUtils
//
//  Created by hehai on 2018/6/22.
//  Copyright © 2018 riversea2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HHScanSuccessBlock)(NSString *resultStr);

@interface HHShadowView : UIView

@property (nonatomic, assign) CGSize showSize;

- (void)stopTimer;

@end


@interface HHQRCodeScanVC : UIViewController

@property (nonatomic, copy) HHScanSuccessBlock completionBlock;

@end
