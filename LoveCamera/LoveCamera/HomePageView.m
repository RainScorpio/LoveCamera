//
//  HomePageView.m
//  LoveCamera
//
//  Created by Rain on 16/3/24.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "HomePageView.h"
#import "Utility.h"
#import "SaveEditedPhotoImage.h"

#define kHOMEPAGEIMAGE @"homePageImage"

@interface HomePageView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *headImageView;


@end


@implementation HomePageView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
    }
    return self;
}


- (void)layoutSubviews {
    [self layoutHomePageUI];
}

- (void)layoutHomePageUI {
    
    UIImage *image = [[NSUserDefaults standardUserDefaults] objectForKey:kHOMEPAGEIMAGE];
    
    if (!image) {
        image = [UIImage imageNamed:@"homepage.jpg"];
    }
   
    
    /** 添加背景图片. */
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundImageView.image = image;
    [self addSubview:_backgroundImageView];
    
    
    /** 添加毛玻璃. */
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualView.frame = _backgroundImageView.frame;
    //    [self.view addSubview:visualView];
    [_backgroundImageView addSubview:visualView];
    
    /** 添加上面的图片. */
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth* 0.1, 30, kMainScreenWidth * 0.8, kMainScreenWidth * 0.8)];
    _headImageView.image = image;
    //    headImageView.layer.borderWidth = 3;
    //    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    
    UIBezierPath *headImagePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-10, -10, _headImageView.frame.size.width + 20, _headImageView.frame.size.width + 20) cornerRadius:20];
    _headImageView.layer.shadowPath = headImagePath.CGPath;
    _headImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _headImageView.layer.shadowRadius = 5;
    _headImageView.layer.shadowOpacity = 0.5 ;
    [self addSubview: _headImageView];
    
    
    UIView *takePhotoView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth * 0.2, (kMainScreenHeight * 0.5) + ((kMainScreenHeight * 0.5) - 100) / 3, kMainScreenWidth * 0.6, 50)];
    takePhotoView.alpha = 0.2;
    takePhotoView.backgroundColor = [UIColor whiteColor];
    takePhotoView.layer.cornerRadius = 25;
    takePhotoView.layer.masksToBounds = YES;
    [self addSubview:takePhotoView];
    
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoButton.frame = takePhotoView.frame;
    [takePhotoButton setTitle:@"拍 照" forState:UIControlStateNormal];
    [takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    takePhotoButton.titleLabel.font = [UIFont italicSystemFontOfSize:30];
    [takePhotoButton addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [takePhotoButton setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:takePhotoButton];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [_headImageView addGestureRecognizer:longPress];
    
    
#pragma mark - 照片库按钮
    UIView *photoesView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth * 0.2, (kMainScreenHeight * 0.5) + ((kMainScreenHeight * 0.5) - 100) / 3 + 100, kMainScreenWidth * 0.6, 50)];
    photoesView.alpha = 0.2;
    photoesView.backgroundColor = [UIColor whiteColor];
    photoesView.layer.cornerRadius = 25;
    photoesView.layer.masksToBounds = YES;
    [self addSubview:photoesView];
    
    UIButton *photoesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoesButton.frame = photoesView.frame;
    [photoesButton setTitle:@"选择照片" forState:UIControlStateNormal];
    [photoesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    photoesButton.titleLabel.font = [UIFont italicSystemFontOfSize:30];
    [photoesButton addTarget:self action:@selector(photoesAction:) forControlEvents:UIControlEventTouchUpInside];
    [photoesButton setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:photoesButton];

    
    
}

#pragma mark - 拍照按钮
- (void)takePhotoAction:(UIButton *)button {
    [self.delegate takePhoto];
}

- (void)photoesAction:(UIButton *)button {
    [self.delegate fetchPhotoes];
}

#pragma mark - 长按手势
- (void)longAction:(UILongPressGestureRecognizer *)longPress {

    [self creatPhotolistCollectionView];
    
}

#pragma mark - 创建照片列表
- (void)creatPhotolistCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kMainScreenHeight * 0.15, kMainScreenHeight * 0.3);
    flowLayout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight * 0.7, kMainScreenWidth, kMainScreenHeight * 0.3) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    
//    
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//
//- (NSInteger)getPhotosCount {
//    
//}


@end
