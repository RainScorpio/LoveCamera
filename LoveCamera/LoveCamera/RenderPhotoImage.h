//
//  RenderPhotoImage.h
//  LoveCamera
//
//  Created by Rain on 16/3/21.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>


@interface RenderPhotoImage : NSObject

@property (nonatomic, strong) CIImage *inputCIImage;

- (UIImage *)senderOutputImage:(UIImage *)inputImage index:(NSUInteger)imageIndex front:(BOOL)isFront;
+ (instancetype)shareRenderPhotoImage;

@end
