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
#import "SaveEditedPhotoImage.h"
#import "Utility.h"
@import Photos; // 导入PhotoKit框架

@interface EditingPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver>
#pragma mark - UI


@property (strong, nonatomic) IBOutlet UIImageView *editingImageView;


@property (strong, nonatomic) IBOutlet UICollectionView *editingImageCollectionView;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;



@property (nonatomic, strong) NSMutableArray *savedImages;
@property (nonatomic, strong) NSIndexPath *didSelectIndexPath;

@end

@implementation EditingPhotoViewController



- (void)viewDidDisappear:(BOOL)animated {
        /** 注销照片库发生改变的通知. */
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 注册照片库发生改变的通知. */
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

    [_editingImageCollectionView registerClass:[PhotoFilterCollectionViewCell class] forCellWithReuseIdentifier:@"photoFilterCell"];
     _editingImageView.image = [[RenderPhotoImage shareRenderPhotoImage] senderOutputImage:[UIImage imageWithData:_editingImageData] index:0 front:self.isFront];

    self.savedImages = [NSMutableArray array];
    self.didSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.editingImageView.userInteractionEnabled = YES;
    [self addSwipeGestureRecognizer];
}

#pragma mark - 滑动手势 
- (void)addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.editingImageView addGestureRecognizer:swipe];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.editingImageView.image] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}




#pragma mark - 给imageView赋值
- (void)setEditingImageData:(NSData *)editingImageData {
    
    _editingImageData = editingImageData;
     [_editingImageCollectionView reloadData];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_editingImageData) {
        return 15;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoFilterCollectionViewCell *photoFilterCell = (PhotoFilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoFilterCell" forIndexPath:indexPath];
    photoFilterCell.displayImage = [[RenderPhotoImage shareRenderPhotoImage] senderOutputImage:[UIImage imageWithData:_editingImageData] index:indexPath.item front:self.isFront];
//    photoFilterCell.text = [[RenderPhotoImage shareRenderPhotoImage] senderLabelText:indexPath.item];
    return photoFilterCell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectIndexPath = indexPath;
     _editingImageView.image = [[RenderPhotoImage shareRenderPhotoImage] senderOutputImage:[UIImage imageWithData:_editingImageData] index:indexPath.item front:self.isFront];
    
    if ([self.savedImages containsObject:indexPath]) {
        [self.saveButton setTitle:@"     已保存" forState:UIControlStateNormal];
    } else {
        [self.saveButton setTitle:@"        保存" forState:UIControlStateNormal];
    }
    
    
}

#pragma mark - 保存照片
- (IBAction)savePhotoImage:(UIButton *)sender {
    
    if (![self.savedImages containsObject:_didSelectIndexPath]) {
        
        SaveEditedPhotoImage *save = [SaveEditedPhotoImage shareSaveEditedPhotoImage];
        [save saveEditedPhotoImage:_editingImageView.image];
        
        
        
        [self.savedImages addObject:_didSelectIndexPath];

        [self.saveButton setTitle:@"正在保存" forState:UIControlStateNormal];
        
        
    } else {
        NSLog(@"您已经保存过.");
    }
    
    
}





- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    
    
    
    PHAssetCollection *collec = [[SaveEditedPhotoImage shareSaveEditedPhotoImage] getLoveCameraAssetCollection];
    
    
    if ([PHAsset fetchAssetsInAssetCollection:collec options:nil].count == 0) {
        
        // 如果是创建相册, 就结束.
        NSLog(@"creat");
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.saveButton setTitle:@"     已保存" forState:UIControlStateNormal];
    });
    
    PHFetchResult *fetch = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:fetch];
    
    if (changeDetails) {
        for (PHObject *pho in changeDetails.changedObjects) {
            
            if (pho.localIdentifier == collec.localIdentifier) {
                
                break;
            }
            
        }
    }
    
    
    
 
}



#pragma mark - 返回按钮
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
