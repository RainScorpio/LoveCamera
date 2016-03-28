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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.displayImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_displayImageView];
        self.renderLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_renderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    
    _displayImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    _renderLabel.frame = CGRectMake(0, self.contentView.frame.size.width - 15, self.contentView.frame.size.width, 15);
    _renderLabel.backgroundColor = [UIColor clearColor];
    _renderLabel.font = [UIFont italicSystemFontOfSize:15];
    _renderLabel.textAlignment = NSTextAlignmentCenter;
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _renderLabel.frame.size.width, _renderLabel.frame.size.height)];
    _renderLabel.layer.shadowPath = bezier.CGPath;
    _renderLabel.layer.shadowColor = [UIColor grayColor].CGColor;
    _renderLabel.layer.shadowOpacity = 0.5;
}


- (void)setDisplayImage:(UIImage *)displayImage {
    
    _displayImage = displayImage;
    self.displayImageView.image = _displayImage;
    
}

- (void)setText:(NSString *)text {
    _text = text;
    self.renderLabel.text = _text;
}

#pragma mark - 设置圆角

//- (void)drawRect:(CGRect)rect {
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.frame cornerRadius:10];
//    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
//    [shape setPath:path.CGPath];
//    self.contentView.layer.mask = shape;
//}


- (void)awakeFromNib {
    // Initialization code
}

@end
