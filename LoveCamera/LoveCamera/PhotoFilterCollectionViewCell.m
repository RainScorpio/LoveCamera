//
//  PhotoFilterCollectionViewCell.m
//  LoveCamera
//
//  Created by Rain on 16/3/21.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "PhotoFilterCollectionViewCell.h"

@interface PhotoFilterCollectionViewCell ()


@property (strong, nonatomic) IBOutlet UIImageView *displayImageView;
@property (strong, nonatomic) IBOutlet UILabel *renderLabel;


@end


@implementation PhotoFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.displayImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_displayImageView];
        self.renderLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_renderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    
    _displayImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    _renderLabel.frame = CGRectMake(0, self.contentView.frame.size.width, self.contentView.frame.size.width, self.contentView.frame.size.height - self.contentView.frame.size.width);
    
    
}


- (void)setDisplayImage:(UIImage *)displayImage {
    
    _displayImage = displayImage;
    self.displayImageView.image = _displayImage;
    
}

- (void)setText:(NSString *)text {
    _text = text;
    self.renderLabel.text = _text;
}


- (void)awakeFromNib {
    // Initialization code
}

@end
