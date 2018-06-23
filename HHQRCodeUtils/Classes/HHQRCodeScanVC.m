//
//  HHQRCodeScanVC.m
//  HHQRCodeUtils
//
//  Created by hehai on 2018/6/22.
//  Copyright © 2018 riversea2015. All rights reserved.
//

#import "HHQRCodeScanVC.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - -------------------------------------------------------------------------------------

@interface HHShadowView ()

@property (nonatomic, strong) UIImageView *scanLine;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation HHShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];

        _scanLine  = [[UIImageView alloc] init];
        _scanLine.image = [UIImage imageNamed:@"line"];
        [self addSubview:_scanLine];
        
    }
    return self;
}

-(void)playAnimation{
    
    [UIView animateWithDuration:2.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.scanLine.frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height + self.showSize.height) / 2, self.showSize.width, 2);
        
    } completion:^(BOOL finished) {
        self.scanLine .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height - self.showSize.height) / 2, self.showSize.width, 2);
    }];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.scanLine.frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height - self.showSize.height) / 2, self.showSize.width, 2);
    
    
    if (!_timer) {
        
        [self playAnimation];
        
        /* 自动播放 */
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
        
    }
    
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 整体颜色
    CGContextSetRGBFillColor(ctx, 0.15, 0.15, 0.15, 0.6);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
    
    // 中间清空矩形框
    CGRect clearDrawRect = CGRectMake((rect.size.width - self.showSize.width) / 2, (rect.size.height - self.showSize.height) / 2, self.showSize.width, self.showSize.height);
    CGContextClearRect(ctx, clearDrawRect);
    
    // 边框
    CGContextStrokeRect(ctx, clearDrawRect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);    // 颜色
    CGContextSetLineWidth(ctx, 0.5);                // 线宽
    CGContextAddRect(ctx, clearDrawRect);           // 矩形
    CGContextStrokePath(ctx);
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    float cornerWidth = 4.0;
    
    float cornerLong = 16.0;
    
    //画四个边角 线宽
    CGContextSetLineWidth(ctx, cornerWidth);
    
    //颜色
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + cornerLong)};
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y + cornerWidth/2),
        CGPointMake(rect.origin.x + cornerLong, rect.origin.y + cornerWidth/2)};
    
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + rect.size.height - cornerLong),
        CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + rect.size.height)};
    
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - cornerWidth/2),
        CGPointMake(rect.origin.x + cornerLong, rect.origin.y + rect.size.height - cornerWidth/2)};
    
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerLong, rect.origin.y + cornerWidth/2),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + cornerWidth/2 )};
    
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x + rect.size.width- cornerWidth/2, rect.origin.y + cornerLong)};
    
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerWidth/2, rect.origin.y+rect.size.height - cornerLong),
        CGPointMake(rect.origin.x- cornerWidth/2 + rect.size.width, rect.origin.y +rect.size.height )};
    
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerLong, rect.origin.y + rect.size.height - cornerWidth/2),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - cornerWidth/2 )};
    
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    
    
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

@end

#pragma mark - -------------------------------------------------------------------------------------

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define customShowSize CGSizeMake(200, 200);

@interface HHQRCodeScanVC ()
<
AVCaptureMetadataOutputObjectsDelegate
>

@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, assign) CGSize layerSize;
@property (nonatomic, assign) CGSize scanSize;
@property (nonatomic, strong) HHShadowView *shadowView;

@end

@implementation HHQRCodeScanVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.presentingViewController) {
        // 创建自定义导航
    }

    self.scanSize = customShowSize;
    [self createScanCode];
    
    [self.view.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    
    [self allowScanRect];
    
    self.shadowView = [[HHShadowView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64)];
    [self.view addSubview:self.shadowView];
    self.shadowView.showSize = _scanSize;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_shadowView stopTimer];
}

#pragma mark -

- (void)createScanCode {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!_input) {
        NSLog(@"Can not get input device!");
        return;
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:_input];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode]; // 🚫 Don't move this line!
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    
    _layerSize = _previewLayer.frame.size;
}

/** 配置扫码范围 */
-(void)allowScanRect{
    
    
    /** 扫描是默认是横屏, 原点在[右上角]
     *  rectOfInterest = CGRectMake(0, 0, 1, 1);
     *  AVCaptureSessionPresetHigh = 1920×1080   摄像头分辨率
     *  需要转换坐标 将屏幕与 分辨率统一
     */
    
    //剪切出需要的大小位置
    CGRect shearRect = CGRectMake((self.layerSize.width - self.scanSize.width) / 2,
                                  (self.layerSize.height - self.scanSize.height) / 2,
                                  self.scanSize.height,
                                  self.scanSize.height);
    
    
    CGFloat deviceProportion = 1920.0 / 1080.0;
    CGFloat screenProportion = self.layerSize.height / self.layerSize.width;
    
    //分辨率比> 屏幕比 ( 相当于屏幕的高不够)
    if (deviceProportion > screenProportion) {
        //换算出 分辨率比 对应的 屏幕高
        CGFloat finalHeight = self.layerSize.width * deviceProportion;
        // 得到 偏差值
        CGFloat addNum = (finalHeight - self.layerSize.height) / 2;
        
        // (对应的实际位置 + 偏差值)  /  换算后的屏幕高
        self.output.rectOfInterest = CGRectMake((shearRect.origin.y + addNum) / finalHeight,
                                                shearRect.origin.x / self.layerSize.width,
                                                shearRect.size.height/ finalHeight,
                                                shearRect.size.width/ self.layerSize.width);
        
    } else {
        
        CGFloat finalWidth = self.layerSize.height / deviceProportion;
        
        CGFloat addNum = (finalWidth - self.layerSize.width) / 2;
        
        self.output.rectOfInterest = CGRectMake(shearRect.origin.y / self.layerSize.height,
                                                (shearRect.origin.x + addNum) / finalWidth,
                                                shearRect.size.height / self.layerSize.height,
                                                shearRect.size.width / finalWidth);
    }
}

#pragma mark - delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        
        [_shadowView stopTimer];
        
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects firstObject];
        NSLog(@"%@", object.stringValue);
        
        if (_completionBlock) {
            _completionBlock(object.stringValue);
        }
        
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
