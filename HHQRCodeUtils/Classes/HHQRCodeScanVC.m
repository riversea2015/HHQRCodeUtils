//
//  HHQRCodeScanVC.m
//  HHQRCodeUtils
//
//  Created by hehai on 2018/6/22.
//  Copyright © 2018 riversea2015. All rights reserved.
//

#import "HHQRCodeScanVC.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface HHQRCodeScanVC ()
<
AVCaptureMetadataOutputObjectsDelegate
>

@end

@implementation HHQRCodeScanVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - initViews


#pragma mark - delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
}

@end
