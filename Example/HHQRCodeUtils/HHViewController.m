//
//  HHViewController.m
//  HHQRCodeUtils
//
//  Created by riversea2015 on 06/21/2018.
//  Copyright (c) 2018 riversea2015. All rights reserved.
//

#import "HHViewController.h"
#import <HHQRCodeUtils/HHQRCodeUtils.h>

static const

@interface HHViewController ()

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Example for HHQRCodeUtils";

    [self setupViews];
}

- (void)setupViews {
    
    UILabel *tipA = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 30)];
    tipA.text = @"扫描二维码";
    [self.view addSubview:tipA];
    
    UIButton *btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPush.backgroundColor = [UIColor redColor];
    btnPush.frame = CGRectMake(10, 120, 100, 50);
    btnPush.tag = 2018062201;
    [btnPush setTitle:@"Push" forState:UIControlStateNormal];
    [btnPush addTarget:self action:@selector(jumpToQRCodeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];
    
    UIButton *btnPresent = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPresent.backgroundColor = [UIColor greenColor];
    btnPresent.frame = CGRectMake(120, 120, 100, 50);
    btnPresent.tag = 2018062202;
    [btnPresent setTitle:@"Present" forState:UIControlStateNormal];
    [btnPresent addTarget:self action:@selector(jumpToQRCodeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPresent];
}

- (void)jumpToQRCodeVC:(UIButton *)sender {
    
    HHQRCodeScanVC *qrVC = [[HHQRCodeScanVC alloc] init];
    qrVC.completionBlock = ^(NSString *resultStr) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultStr]];
    };
    
    if (sender.tag == 2018062201) {
        [self.navigationController pushViewController:qrVC animated:YES];
    } else {
        [self presentViewController:qrVC animated:YES completion:nil];
    }
}

@end
