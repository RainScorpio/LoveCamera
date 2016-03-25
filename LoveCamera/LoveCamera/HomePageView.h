//
//  HomePageView.h
//  LoveCamera
//
//  Created by Rain on 16/3/24.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageViewDelegate <NSObject>

- (void)takePhoto;

@end

@interface HomePageView : UIView
@property (nonatomic, strong) UIImage *homePagebackgroundImage;
@property (nonatomic, assign) id<HomePageViewDelegate> delegate;
@end
