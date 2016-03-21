//
//  RenderPhotoImage.m
//  LoveCamera
//
//  Created by Rain on 16/3/21.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "RenderPhotoImage.h"

@interface RenderPhotoImage ()

//@property (nonatomic, strong)   CIContext *context;
//@property (nonatomic, strong  CIFilter *colorControlsFilter;
@property (nonatomic, strong) NSDictionary *filtersDic;
@property (nonatomic, strong) NSMutableArray *filtersArray;


@end

@implementation RenderPhotoImage

- (instancetype)init {
    self = [super init];
    if (self) {
        
//        self.colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
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
                                     
                                     };
        self.filtersArray = [NSMutableArray array];
        for (NSString *key in _filtersDic.allKeys) {
            
            [_filtersArray addObject:[CIFilter filterWithName:[_filtersDic objectForKey:key]]];
            
        }
        
        
    }
    return self;
}

- (UIImage *)senderOutputImage:(UIImage *)inputImage index:(NSUInteger)imageIndex {
    
    CIFilter *filter = [_filtersArray objectAtIndex:imageIndex];
    
    [filter setValue:[CIImage imageWithCGImage:inputImage.CGImage] forKey:@"inputImage"];
    CIImage *outputCIImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef temp = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    
    UIImage *outputImage = [UIImage imageWithCGImage:temp];
    CGImageRelease(temp);
    return outputImage;
}

- (NSString *)senderLabelText:(NSUInteger)imageIndex {
    return [_filtersDic.allKeys objectAtIndex:imageIndex];
}


@end
