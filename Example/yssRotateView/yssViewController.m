//
//  yssViewController.m
//  yssRotateView
//
//  Created by acct<blob>=0xE8B5A4E9B1AC on 03/22/2017.
//  Copyright (c) 2017 acct<blob>=0xE8B5A4E9B1AC. All rights reserved.
//

#import "yssViewController.h"
#import <yssRotateView/yssRotateView.h>
#import "yssBannerCell.h"

@interface yssViewController ()
@property(nonatomic,strong)yssRotateView*yssBanner;
@end

@implementation yssViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //视图创建
    self.yssBanner=[[yssRotateView alloc]initWithCellViewClass:[yssBannerCell class] autoRotate:YES idleTime:5.0 pageIndicatorTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.12] currentPageIndicatorTintColor:[UIColor whiteColor] pageContrlFromBottom:8 pageControlHeight:6.5 clickIndexHandle:^(NSInteger index) {
        ;//一般用于写死的跳转链接
    }];
    [self.view addSubview:self.yssBanner];
    [self.yssBanner setFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100)];
    self.yssBanner.backgroundColor=[UIColor greenColor];
    
    //数据绑定
    NSArray *data=@[[UIImage imageNamed:@"aaa.png"],[UIImage imageNamed:@"bbb.png"],[UIImage imageNamed:@"aaad.jpg"]];
    [self.yssBanner bindCellDataWithcellsCount:[data count] bindCellDataHandle:^( UIView*v, NSInteger index) {
        [(yssBannerCell*)v bindCellData:[data objectAtIndex:index]];//记得需要强制转化;这里表示的是第index个view需要执行的操作
    }];
        
       
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yssBanner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yssBanner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yssBanner attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yssBanner attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//self.banner=[[STRotateView alloc]initWithCellViewClass:[cellBannerView class] autoRotate:YES idleTime:5.0 pageIndicatorTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.12] currentPageIndicatorTintColor:[UIColor whiteColor] pageContrlFromBottom:8 pageControlHeight:6.5 clickIndexHandle:^(NSInteger index) {
//    ;//一般用于写死的跳转链接
//}];
//[self addSubview:_banner];
//[self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.center.mas_equalTo(self);
//    make.size.mas_equalTo(self);
//}];
//}
//
//-(void)bindData:(NSArray<activity>*)data{
//    
//    
//    [self.banner bindCellDataWithcellsCount:[data count] bindCellDataHandle:^(UIView *v, NSInteger index) {
//        
//        [(cellBannerView*)v bindCellData:[data objectAtIndex:index]];//记得需要强制转化
//    }];
