//
//  HomePageViewController.m
//  LoveCamera
//
//  Created by Rain on 16/3/24.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "HomePageViewController.h"
#import "CustomCameraViewController.h"
#import "Utility.h"
#import "HomePageView.h"

@interface HomePageViewController ()<HomePageViewDelegate>

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    HomePageView *backgroundView = [[HomePageView alloc] init];
    backgroundView.delegate = self;
    [self.view addSubview:backgroundView];
}


- (void)takePhoto {
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
