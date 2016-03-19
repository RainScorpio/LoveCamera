//
//  TakePhotoView.m
//  LoveCamera
//
//  Created by Rain on 16/3/18.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "TakePhotoView.h"
#import "Utility.h"

@interface TakePhotoView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TakePhotoView

#pragma mark - 重写初始化方法和便利构造器
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

+ (instancetype)takePhotoViewWithPhotoImage:(UIImage *)image {
    
    TakePhotoView *view = [[TakePhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.imageView.image = image;
    return view;
    
}

- (void)layoutSubviews {
    
    self.backgroundColor = [UIColor colorWithRed:114 green:254 blue:224 alpha:1];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight - 104)];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    
    UIButton *reTakePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reTakePhotoButton.frame = CGRectMake(8, kMainScreenHeight - 44, 77, 36);
    reTakePhotoButton.backgroundColor = [UIColor colorWithRed:255 green:250 blue:194 alpha:1];
    [reTakePhotoButton setTitle:@"重拍" forState:UIControlStateNormal];
    [reTakePhotoButton addTarget:self action:@selector(reTakePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reTakePhotoButton];
    
    UIButton *usePhotoImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    usePhotoImageButton.frame = CGRectMake(kMainScreenWidth - 85, kMainScreenWidth - 44, 77, 36);
    usePhotoImageButton.backgroundColor = [UIColor colorWithRed:255 green:250 blue:194 alpha:1];
    [usePhotoImageButton addTarget:self action:@selector(usePhotoimageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:usePhotoImageButton];
    
    
}

- (void)reTakePhotoAction:(UIButton *)sender {
    [self.delegate reTakePhoto];
}

- (void)usePhotoimageAction:(UIButton *)sender {
    [self.delegate useTakePhotoImage:self.imageView.image];
}


@end
