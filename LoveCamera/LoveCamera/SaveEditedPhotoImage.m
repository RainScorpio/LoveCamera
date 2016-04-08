//
//  SaveEditedPhotoImage.m
//  LoveCamera
//
//  Created by Rain on 16/3/21.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "SaveEditedPhotoImage.h"

@interface SaveEditedPhotoImage ()
//<PHPhotoLibraryChangeObserver> /**< 协议用于通知照片库中发生的变化. */

@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic, strong) PHAssetCollection *albumAssetCollection;



@end

@implementation SaveEditedPhotoImage

static NSString * const AdjustmentFormatIdentifier = @"com.rain.LoveCamera";
static NSString * const MyselfAlbumName = @"LoveCamera";
static NSString * const localIdentifier = @"LoveCameraLocalIdentifier";


+ (instancetype)shareSaveEditedPhotoImage {
    static SaveEditedPhotoImage *save = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        save = [[SaveEditedPhotoImage alloc] init];
    });
    return save;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
               
    }
    return self;
}



// 第一次使用应用程序, 创建一个LoveCamera的相片文件夹
- (void)createNewAlbum {
    
    /**
     * [PHPhotoLibrary sharedPhotoLibrary] 对象是代表用户的照片库, 包括本地和已经启用的iCloud.
     * - performChanges:completionHandler: 在照片库中异步运行请求更改的block块.
     */
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        /**
         * PHAssetCollectionChangeRequest 可以用PHAssetCollectionChangeRequest的对象在照片库更改的block块(也就是现在这个块里)去创建, 删除或者更改PHAssetCollection的对象
         */
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:MyselfAlbumName];
        
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"Error creating ablum: %@", error);
        } else {
            NSLog(@"创建成功.");
            PHFetchResult *loveCameraAssetFetchResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
            PHCollection *myCollection = loveCameraAssetFetchResult.lastObject;
           
            [[NSUserDefaults standardUserDefaults] setValue:myCollection.localIdentifier  forKey:localIdentifier];
            self.albumAssetCollection = loveCameraAssetFetchResult.lastObject;
            [self saveAction:_saveImage];
        }
    }];
    
    
}



- (void)saveAction:(UIImage *)image {
    
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        
        
        // 创建一个PHAssetChangeRequest对象, 用于创建一个新的PHAsset.
        PHAssetChangeRequest *creatAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHObjectPlaceholder *assetPlaceholder = creatAssetRequest.placeholderForCreatedAsset;
        PHAssetCollectionChangeRequest *ablumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.albumAssetCollection];
        [ablumChangeRequest addAssets:@[assetPlaceholder]];
        
        
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            
            NSLog(@"Create PHAsset Error: %@", error);
        } else {
            NSLog(@"保存成功!");
        }
    }];

}

- (void)saveEditedPhotoImage:(UIImage *)image {
    
    self.saveImage = image;
    
    NSString *strIden = [[NSUserDefaults standardUserDefaults] stringForKey:localIdentifier];
    if (strIden) {
        self.albumAssetCollection = [self getLoveCameraAssetCollection];
        [self saveAction:image];
        
    } else {
        
        [self createNewAlbum];
    }
    
    
    
}


- (PHAssetCollection *)getLoveCameraAssetCollection {
    
    PHAssetCollection *ac = [[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[[[NSUserDefaults standardUserDefaults] stringForKey:localIdentifier]] options:nil] firstObject];
    
    return ac;
}





@end
