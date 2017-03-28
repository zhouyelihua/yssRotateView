//
//  yssBannerCell.h
//  yssRotateView
//
//  Created by maoer on 2017/3/27.
//  Copyright © 2017年 acct<blob>=0xE8B5A4E9B1AC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface yssBannerModel:NSObject
@property(nonatomic,strong)UIImage*image;
@end

@interface yssBannerCell : UIView
-(void)bindCellData:(UIImage*)celldata;
@end
