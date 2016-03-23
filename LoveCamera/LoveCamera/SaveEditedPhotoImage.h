//
//  SaveEditedPhotoImage.h
//  LoveCamera
//
//  Created by Rain on 16/3/21.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveEditedPhotoImage : NSObject

+ (instancetype)shareSaveEditedPhotoImage;
- (void)saveEditedPhotoImage:(UIImage *)image;

@end
