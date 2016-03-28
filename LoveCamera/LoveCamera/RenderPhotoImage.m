//
//  RenderPhotoImage.m
//  LoveCamera
//
//  Created by Rain on 16/3/21.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "RenderPhotoImage.h"

@interface RenderPhotoImage ()

@property (nonatomic, strong) NSDictionary *filtersDic;
@property (nonatomic, strong) NSMutableArray *filtersArray;
@property (nonatomic, strong) NSArray *filterTitle;


@end




@implementation RenderPhotoImage

+ (instancetype)shareRenderPhotoImage {
    
    static RenderPhotoImage *photoImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoImage = [[RenderPhotoImage alloc] init];
    });
    return photoImage;
    
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.filtersDic = @{
                                     @"None": @"CIColorControls" ,
                                     @"Mono": @"CIPhotoEffectMono",
                                     @"Tonal": @"CIPhotoEffectTonal",
                                     @"Noir": @"CIPhotoEffectNoir",
                                     @"Fade": @"CIPhotoEffectFade",
                                     @"Chrome": @"CIPhotoEffectChrome",
                                     @"Process": @"CIPhotoEffectProcess",
                                     @"Transfer": @"CIPhotoEffectTransfer",
                                     @"Instant" :@"CIPhotoEffectInstant",
                                     
                                     @"Matrix": @"CIColorMatrix",
                                     
                                     @"SRGBToneCure": @"CILinearToSRGBToneCurve",
                                     @"TemperatureAndTint": @"CITemperatureAndTint",
                                     
                                     
                                     @"CIColorInvert": @"CIColorInvert",
                                     
                                     
                                     @"CIDepthOfField": @"CIDepthOfField",
                                     
                                     @"CILineOverlay": @"CILineOverlay"
                                     };
        
        //kCICategoryStillImage, kCICategoryBuiltIn, kCICategoryFilterGenerator
//        self.filterTitle = [CIFilter filterNamesInCategories:@[kCICategoryStillImage]];
        self.filtersArray = [NSMutableArray array];
        for (NSString *key in _filtersDic) {
            
            [_filtersArray addObject:[CIFilter filterWithName:[_filtersDic objectForKey:key]]];
            
        }
        
        
    }
    return self;
}

- (UIImage *)senderOutputImage:(UIImage *)inputImage index:(NSUInteger)imageIndex {
    
    CIFilter *filter = [_filtersArray objectAtIndex:imageIndex];
    
    [filter setValue:[CIImage imageWithCGImage:inputImage.CGImage] forKey:kCIInputImageKey];
    CIImage *outputCIImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef temp = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    
#pragma mark ???
    UIImage *uiImage = [[UIImage alloc] initWithCGImage:temp scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(temp);
    return uiImage;
}

- (NSString *)senderLabelText:(NSUInteger)imageIndex {
    return [_filtersDic.allKeys objectAtIndex:imageIndex];
}


@end
