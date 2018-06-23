//
//  HHViewController.m
//  HHQRCodeUtils
//
//  Created by hehai on 06/21/2018.
//  Copyright (c) 2018 riversea2015. All rights reserved.
//

#import "HHViewController.h"
#import <HHQRCodeUtils/HHQRCodeUtils.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface HHViewController ()

@property (nonatomic, strong) UIImageView *qrImgv;
@property (nonatomic, strong) UILabel *resultLab;

@end

@implementation HHViewController

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Example for HHQRCodeUtils";

    [self setupViews];
}

#pragma mark - initViews

- (void)setupViews {
    
    /// Scan QRCode
    
    [self createLabWithText:@"Scan QRCode" frame:CGRectMake(10, 80, self.view.frame.size.width - 20, 30)];
    
    [self createBtnWithTitle:@"Push" tag:2018062201 frame:CGRectMake(10, 120, 100, 50) bgColor:[UIColor redColor]];
    [self createBtnWithTitle:@"Present" tag:2018062202 frame:CGRectMake(120, 120, 100, 50) bgColor:[UIColor greenColor]];
    
    /// Generate and detect QRCode
    
    [self createLabWithText:@"Scan QRCode" frame:CGRectMake(10, 185, self.view.frame.size.width - 20, 30)];
    
    [self createBtnWithTitle:@"Generate" tag:2018062203 frame:CGRectMake(10, 230, 100, 50) bgColor:[UIColor orangeColor]];
    [self createBtnWithTitle:@"Generate" tag:2018062204 frame:CGRectMake(120, 230, 100, 50) bgColor:[UIColor purpleColor]];
    [self createBtnWithTitle:@"Detect" tag:2018062205 frame:CGRectMake(230, 230, 100, 50) bgColor:[UIColor magentaColor]];
    
    _qrImgv = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW-200)/2, 300, 200, 200)];
    [self.view addSubview:_qrImgv];
    
    _resultLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 520, kScreenW-20, 30)];
    _resultLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_resultLab];
}

#pragma mark - Action

- (void)jumpToQRCodeVC:(UIButton *)sender {
    
    HHQRCodeScanVC *qrVC = [[HHQRCodeScanVC alloc] init];
    qrVC.completionBlock = ^(NSString *resultStr) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultStr]];
    };
    
    switch (sender.tag) {
        case 2018062201:
        {
            NSLog(@"暂未实现");
//            [self.navigationController pushViewController:qrVC animated:YES];
        }
            break;
        case 2018062202:
        {
            NSLog(@"暂未实现");
//            [self presentViewController:qrVC animated:YES completion:nil];
        }
            break;
        case 2018062203:
            {
                _resultLab.text = nil;
                _qrImgv.image = [HHQRImageGenerator createQRImageWithContents:@"https://github.com/riversea2015"
                                                                       qrSize:CGSizeMake(268, 268)
                                                                      bgImage:nil
                                                                       bgSize:CGSizeMake(288, 288)
                                                                    logoImage:[UIImage imageNamed:@"testA"]
                                                                     logoSize:CGSizeMake(64, 64)];
            }
            break;
        case 2018062204:
            {
                _resultLab.text = nil;
                _qrImgv.image = [HHQRImageGenerator createQRImgWithContents:@"http://weibo.com/riversea2015"
                                                                     qrSize:CGSizeMake(268, 268)
                                                                    bgImage:nil
                                                                     bgSize:CGSizeMake(288, 288)
                                                                  logoImage:[UIImage imageNamed:@"testB"]
                                                                   logoSize:CGSizeMake(64, 64)
                                                                 logoRadius:10];
            }
            break;
        case 2018062205:
            {
                _resultLab.text = [HHQRImageGenerator detectQRImage:_qrImgv.image];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Tools

- (void)createLabWithText:(NSString *)text frame:(CGRect)frame {
    UILabel *tip = [[UILabel alloc] initWithFrame:frame];
    tip.text = text;
    [self.view addSubview:tip];
}

- (void)createBtnWithTitle:(NSString *)title tag:(NSInteger)tag frame:(CGRect)frame bgColor:(UIColor *)color {
    
    UIButton *btnPresent = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPresent.backgroundColor = color;
    btnPresent.frame = frame;
    btnPresent.tag = tag;
    [btnPresent setTitle:title forState:UIControlStateNormal];
    [btnPresent addTarget:self action:@selector(jumpToQRCodeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPresent];
}

@end
