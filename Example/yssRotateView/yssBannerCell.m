//
//  yssBannerCell.m
//  yssRotateView
//
//  Created by maoer on 2017/3/27.
//  Copyright © 2017年 acct<blob>=0xE8B5A4E9B1AC. All rights reserved.
//

#import "yssBannerCell.h"
@implementation yssBannerModel
@end
@interface yssBannerCell()
@property(nonatomic,strong)UIImageView*imgView;
@end
@implementation yssBannerCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.imgView=[UIImageView new];
    [self addSubview:self.imgView];
    _imgView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
//    masonry
//    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//        make.size.mas_equalTo(self);
//    }];

}

-(void)bindCellData:(UIImage*)celldata{
    self.imgView.image=celldata;

}

@end
