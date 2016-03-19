//
//  TakePhotoView.h
//  LoveCamera
//
//  Created by Rain on 16/3/18.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakePhotoViewDelegte <NSObject>

- (void)reTakePhoto;
- (void)useTakePhotoImage:(UIImage *)editingImage;


@end

@interface TakePhotoView : UIView

@property (nonatomic, assign) id<TakePhotoViewDelegte> delegate;

+ (instancetype)takePhotoViewWithPhotoImage:(UIImage *)image;

@end
