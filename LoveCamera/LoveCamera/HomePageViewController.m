//
//  HomePageViewController.m
//  LoveCamera
//
//  Created by Rain on 16/3/24.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "HomePageViewController.h"
#import "CustomCameraViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    takePhotoButton.frame = CGRectMake(30, 100, 100, 50);
    [takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoButton];
}

- (void)takePhotoAction:(UIButton *)button {
    CustomCameraViewController *ccVC = [[CustomCameraViewController alloc] init];
    [self.navigationController pushViewController:ccVC animated:YES];
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
