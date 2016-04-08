//
//  CustomCameraViewController.m
//  LoveCamera
//
//  Created by Rain on 16/3/18.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "CustomCameraViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "EditingPhotoViewController.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface CustomCameraViewController ()<UIGestureRecognizerDelegate, AVCaptureMetadataOutputObjectsDelegate>



#pragma mark - 界面控件.
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (weak, nonatomic) IBOutlet UIButton *cancleTakePhotoButton;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *frontCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *usePhotoImage;


#pragma mark - AVFoundation
@property (nonatomic) dispatch_queue_t sessionQueue; /**< 猜测是单例或者唯一值. */
@property (nonatomic, strong) AVCaptureSession *session; /**< AVCaptureSession对象用来执行输入设备和输出设备之间的数据传递. */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput; /**< 调用所有输入设备, 例如摄像头和麦克风. */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; /**< 镜头捕捉得到的预览图层. */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput; /**< 照片输出流, 用于输出图像. */
@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, assign) CGFloat beginGestureScale; /**< 开始的缩放比例. */
@property (nonatomic, assign) CGFloat effectiveScale; /**< 最后的缩放比例. */


#pragma mark - 数据
@property (nonatomic, assign) BOOL isFrontCamera; /**< 判断是否是前置摄像头. */
@property (nonatomic, strong) NSData *imageData;


@end

@implementation CustomCameraViewController

//static NSString * const sq = @"com.rain.LoveCamera";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.takePhotoButton.layer.cornerRadius = self.takePhotoButton.frame.size.width / 2;
    // 设置session及相关配置.
//    self.sessionQueue = dispatch_queue_create("com.rain.LoveCamera", DISPATCH_QUEUE_SERIAL);
    
    [self createAVCaptureSession];
    
    // 创建缩放手势, 调整焦距.
    [self addPinchGesture];
    
    self.isFrontCamera = YES;
    self.beginGestureScale = 1.0f;
    self.effectiveScale = 1.0f;
    self.usePhotoImage.hidden = YES;


}

#pragma mark - 开启session
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.session) {
        [self.session startRunning];
    }
    
    [self changeUI:NO];
}

#pragma mark - 隐藏状态栏(iOS9)
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 关闭session
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (self.session) {
        [self.session stopRunning];
//            dispatch_async(_sessionQueue, ^{
//                
//            });
    }
}



#pragma mark - 对输入输出进行设置.

- (void)createAVCaptureSession {
    
#pragma mark ???
    
    // 创建数据传输对象.
    self.session = [[AVCaptureSession alloc] init];
    
    // 设置session允许定义音频视频录制的质量.
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    // 创建设备对象.
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 更改设置前锁定设备.
    [device lockForConfiguration:nil];
    
    // 设置闪光灯为自动.
    [device setFlashMode:AVCaptureFlashModeAuto];
    
    // 更改完成解锁设备
    [device unlockForConfiguration];
    
    // 创建输入设备对象
    NSError *error;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%s, %d: %@", __func__, __LINE__, error);
    }
    
    
    

    
    // 创建输出图像对象.
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    
    
   
    
    // 输出设置: AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary *outoutSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outoutSettings];
    
    // 先判断session是否能添加输入设备.
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    // 创建预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
#pragma mark 设置预览图层的填充方式.
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, kMainScreenWidth, self.backgroundView.frame.size.height);
    
    // 将预览图层添加到背景视图上.
    self.backgroundView.layer.masksToBounds = YES;
    [self.backgroundView.layer addSublayer:self.previewLayer];
    [self.view sendSubviewToBack:_backgroundView];
    
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == AVCaptureDevicePositionFront) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    
//    [self captureFace];
}



#pragma mark - 创建缩放和点击手势
- (void)addPinchGesture {
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.backgroundView addGestureRecognizer:pinch];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [self.backgroundView addGestureRecognizer:tap];
}

#pragma mark - 手动对焦
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    CGPoint point = [tap locationInView:self.backgroundView];
    CGPoint autoPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [device lockForConfiguration:nil];
    device.focusPointOfInterest = autoPoint;
    device.focusMode = AVCaptureFocusModeAutoFocus;
    
    
    
    [device setExposureModeCustomWithDuration:device.activeFormat.maxExposureDuration ISO:device.activeFormat.maxISO completionHandler:nil];
    [device setFocusModeLockedWithLensPosition:0.5 completionHandler:^(CMTime syncTime) {
        
    }];
    
    [device unlockForConfiguration];
}
#pragma mark  调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinch {
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [pinch numberOfTouches];

#pragma mark ???
    for (NSUInteger i = 0; i < numTouches; i++) {
        CGPoint location = [pinch locationOfTouch:i inView:self.backgroundView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if (![self.previewLayer containsPoint:convertedLocation]) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        self.effectiveScale = self.beginGestureScale * pinch.scale;
        if (self.effectiveScale < 1.0) {
            self.effectiveScale = 1.0;
        }
    }
    
    NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,pinch.scale);
    
    CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
    
    NSLog(@"%f", maxScaleAndCropFactor);
    
    if (self.effectiveScale > maxScaleAndCropFactor)
        self.effectiveScale = maxScaleAndCropFactor;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
    [CATransaction commit];
    
}

#pragma mark 手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - 获取设备方向, 要在配置图片输出的时候需要使用
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        result = AVCaptureVideoOrientationLandscapeRight;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        result = AVCaptureVideoOrientationLandscapeLeft;
    }
    
    
    return  result;
}


#pragma mark - 识别人脸
- (void)captureFace {
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:_sessionQueue];
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    for (AVMetadataObject *metadataObject in metadataObjects) {
        if (metadataObject.type == AVMetadataObjectTypeFace) {
            [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        }
    }
    
}

#pragma mark - 拍照按钮 ???
- (IBAction)takePhotoButton:(UIButton *)sender {
    
    // session通过AVCaptureConnection连接AVCaptureStillImageOutput进行图片输出.
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 获取当前的设备方向
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    
//    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    
    // 控制焦距
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        self.imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        if (self.imageData) {
            [self changeUI:YES];
            return;
        }
        
        
    }];
    
}



#pragma mark - 取消拍照.
- (IBAction)cancleTakePhotoButton:(UIButton *)sender {
    
    if (sender.selected) {
        [self changeUI:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}

#pragma mark - 闪光灯
- (IBAction)flashButton:(UIButton *)sender {
   AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:nil];
    
    // 设置对焦模式
    device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    // 先判断设备是否有闪光灯
    if ([device hasFlash]) {
        switch (device.flashMode) {
            case AVCaptureFlashModeAuto: {
                device.flashMode = AVCaptureFlashModeOn;
                [sender setImage:[UIImage imageNamed:@"startFlash.png"] forState:UIControlStateNormal];
                break;
            }
            case AVCaptureFlashModeOn: {
                device.flashMode = AVCaptureFlashModeOff;
                [sender setImage:[UIImage imageNamed:@"closeFlash.png"] forState:UIControlStateNormal];
                break;
            }
            case AVCaptureFlashModeOff: {
                device.flashMode = AVCaptureFlashModeAuto;
                [sender setImage:[UIImage imageNamed:@"autoFlash.png"] forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
    } else {
        NSLog(@"设备不支持闪光灯.");
    }
    
    [device unlockForConfiguration];
    
    
}



#pragma mark - 转换前后摄像头.
- (IBAction)conversionCameraType:(UIButton *)sender {
    
    
    
   AVCaptureDevicePosition desiredPosition;

    if (self.isFrontCamera) {
        desiredPosition = AVCaptureDevicePositionBack;
        //        [sender setTitle:@"后" forState:UIControlStateNormal];
    } else {
        desiredPosition = AVCaptureDevicePositionFront;
        //        [sender setTitle:@"前" forState:UIControlStateNormal];
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    [UIView transitionWithView:self.backgroundView duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        
            }];
    
    self.isFrontCamera = !self.isFrontCamera;
    
    
}

#pragma mark - 拍照后的界面
- (void)changeUI:(BOOL)isPhotoImageUI {
    
    // isPhotoImageUI 为YES时是照片界面
    if (isPhotoImageUI) {
        
        [self.session stopRunning];
        self.takePhotoButton.hidden = YES;
        self.flashButton.hidden = YES;
        self.frontCameraButton.hidden = YES;
        self.cancleTakePhotoButton.selected = 1;
        self.usePhotoImage.hidden = NO;
        
    } else {
        [self.session startRunning];
        self.takePhotoButton.hidden = NO;
        self.flashButton.hidden = NO;
        self.frontCameraButton.hidden = NO;
        self.cancleTakePhotoButton.selected = 0;
        self.usePhotoImage.hidden = YES;
    }
    
}

#pragma mark - 点击使用照片按钮

- (IBAction)usePhotoImageAction:(UIButton *)sender {
    
    EditingPhotoViewController *editingVC = [[EditingPhotoViewController alloc] init] ;
    
    editingVC.editingImageData = self.imageData;
    editingVC.isFront = _isFrontCamera;
    [self.navigationController pushViewController:editingVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
