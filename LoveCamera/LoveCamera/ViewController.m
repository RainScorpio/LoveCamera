//
//  ViewController.m
//  LoveCamera
//
//  Created by Rain on 16/3/16.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "ViewController.h"
#import "CustomCameraViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 拍照

- (IBAction)camera {
    
    CustomCameraViewController *ccVC = [[CustomCameraViewController alloc] init];
    [self presentViewController:ccVC animated:YES completion:nil];
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [self snapImage];
//        
//    } else {
//        NSLog(@"%s, %d: 没有摄像头", __func__, __LINE__);
//    }

}

#pragma mark 跳转到照相机UIImagePickerController
- (void)snapImage {

    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePick.delegate = self;
    [self presentViewController:imagePick animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
