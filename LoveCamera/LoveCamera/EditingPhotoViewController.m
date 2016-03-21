//
//  EditingPhotoViewController.m
//  LoveCamera
//
//  Created by Rain on 16/3/19.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "EditingPhotoViewController.h"
#import "RenderPhotoImage.h"
#import "PhotoFilterCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h> /**< 管理照片的系统框架. */

@interface EditingPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
#pragma mark - UI

@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;
@property (nonatomic, strong) RenderPhotoImage *renderImage;

@property (weak, nonatomic) IBOutlet UICollectionView *editingImageCollectionView;

@end

@implementation EditingPhotoViewController



// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [_editingImageCollectionView registerClass:[PhotoFilterCollectionViewCell class] forCellWithReuseIdentifier:@"photoFilterCell"];

}

#pragma mark - 给imageView赋值
- (void)setEditingImageData:(NSData *)editingImageData {
    
    _editingImageData = editingImageData;
    
    self.renderImage = [[RenderPhotoImage alloc] init];
    
//    _editingImageView.image = [UIImage imageWithData:_editingImageData];
    _editingImageView.image = [_renderImage senderOutputImage:[UIImage imageWithData:_editingImageData] index:0];
    
    [_editingImageCollectionView reloadData];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_editingImageData) {
        return 9;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoFilterCollectionViewCell *photoFilterCell = (PhotoFilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoFilterCell" forIndexPath:indexPath];
    photoFilterCell.displayImage = [_renderImage senderOutputImage:[UIImage imageWithData:_editingImageData] index:indexPath.item];
    photoFilterCell.text = [_renderImage senderLabelText:indexPath.item];
    return photoFilterCell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
     _editingImageView.image = [_renderImage senderOutputImage:[UIImage imageWithData:_editingImageData] index:indexPath.item];
    
}

#pragma mark - 保存照片
- (IBAction)savePhotoImage:(UIButton *)sender {
    
    
//            CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
//    
//            // 此方法iOS9已被废弃, 使用PhotoKit框架代替.
//            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//            if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
//                // 无权限
//                return;
//            }
//    
//            ALAssetsLibrary *libray = [[ALAssetsLibrary alloc] init];
//            [libray writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//    
//            }];
//            
    

    
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
