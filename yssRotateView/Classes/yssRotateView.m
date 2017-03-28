//
//  yssRotateView.m
//  Pods
//
//  Created by maoer on 2016/12/5.
//
//

#import "yssRotateView.h"
@interface yssRotateView()
@property(nonatomic,strong)yssRotateViewClickIndexBlock block;
@property(nonatomic,strong)yssBindCellDataIndexBlock   bindCellDataBlock;
@property(nonatomic,assign)BOOL autoRotate;
@property(nonatomic,assign)CGFloat idleTime;
@property(nonatomic,assign)CGFloat pageContrlFromBottom;
@property(nonatomic,assign)CGFloat pageControlHeight;
@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,assign)NSInteger curPage;
@property(nonatomic,assign)NSInteger totalPages;
@property(nonatomic,strong)UIColor*currentPageIndicatorTintColor;
@property(nonatomic,strong)UIColor*pageIndicatorTintColor;
@property(nonatomic,strong)NSTimer*timer;
@property(nonatomic,strong)Class cellViewClass;
@property(nonatomic,strong)NSArray<UIView*>*containerViews;
@end

@implementation yssRotateView

-(instancetype)initWithCellViewClass:(Class)cellViewClass
                          autoRotate:(BOOL)autoRotate
                            idleTime:(CGFloat)idleTime
              pageIndicatorTintColor:(UIColor*)pageIndicatorTintColor
       currentPageIndicatorTintColor:(UIColor*)currentPageIndicatorTintColor
                pageContrlFromBottom:(CGFloat)pageContrlFromBottom
                   pageControlHeight:(CGFloat)pageControlHeight
                    clickIndexHandle:(yssRotateViewClickIndexBlock)handle{
    self=[super  init];
    if(self){
        self.autoRotate=autoRotate;
        self.cellViewClass=cellViewClass;
        self.pageControlHeight=pageControlHeight;
        self.pageContrlFromBottom=pageContrlFromBottom;
        NSMutableArray* tmpContainerViews=[NSMutableArray new];
        for(int i=0;i<3;i++){
            UIView *v=[cellViewClass new];
            [tmpContainerViews addObject:v];
        }
        self.containerViews=[tmpContainerViews copy];
        self.idleTime=idleTime;
        self.block=handle;
        self.pageIndicatorTintColor=pageIndicatorTintColor;
        self.currentPageIndicatorTintColor=currentPageIndicatorTintColor;
        [self setupView];
    }
    return self;
}
-(void)layoutSubviews{
    _scrollView.frame=self.bounds;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    if(self.totalPages>1)
        [self manualLoadData];
}
-(void) bindCellDataWithcellsCount:(NSInteger)count bindCellDataHandle:(yssBindCellDataIndexBlock)bindDataBlock{
    self.totalPages=count;
    self.bindCellDataBlock=bindDataBlock;
    _pageControl.numberOfPages=self.totalPages;
    _scrollView.scrollEnabled=(_totalPages>1);
    [self manualLoadData];
    if(self.autoRotate&&self.totalPages>1)
        [self startRotate];
}
-(void) setupView{
    // Initialization code
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    //_scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    //_scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _scrollView.decelerationRate=UIScrollViewDecelerationRateFast;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    _scrollView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    //    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.mas_equalTo(self);
    //        make.size.mas_equalTo(self);
    //    }];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor=self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor=self.currentPageIndicatorTintColor;
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    _pageControl.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-1*_pageContrlFromBottom]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_pageControlHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    //    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(self.mas_centerX);
    //        make.bottom.mas_equalTo(self.mas_bottom).offset(-1.0*self.pageContrlFromBottom);
    //        make.height.mas_equalTo(self.pageControlHeight);
    //        make.width.mas_equalTo(self.mas_width);
    //    }];
    [self bringSubviewToFront:_pageControl];
    _curPage = 0;
}
-(void)startRotate{
    if(!self.timer){
        self.timer = [NSTimer timerWithTimeInterval:self.idleTime target:self selector:@selector(autoRotateView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void)autoRotateView{
    _curPage = [self validPageValue:_curPage+1];
    [self autoLoadData];
}
#pragma mark -loadData
-(void)autoLoadData{
    [self loadData];
    //为了自动滚动的效果
    [_scrollView setContentOffset:CGPointMake(0.5, 0) animated:NO];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}
- (void)manualLoadData
{
    [self loadData];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
-(void)loadData{
    _pageControl.currentPage = _curPage;
    
    [self getDisplayImagesWithCurpage:_curPage];
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    for (int i = 0; i < 3; i++) {
        self.containerViews[i].userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [self.containerViews[i] addGestureRecognizer:singleTap];
        self.containerViews[i].frame=CGRectMake(self.bounds.size.width* i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:self.containerViews[i]];
    }
}
- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    self.bindCellDataBlock(self.containerViews[0],pre);
    self.bindCellDataBlock(self.containerViews[1],page);
    self.bindCellDataBlock(self.containerViews[2],last);
}
//复制UIView
- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
- (int)validPageValue:(NSInteger)value {
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    return value;
}

- (void)stopScroll{
    [self.timer invalidate];
    //self.autoScrolling=NO;
    self.timer = nil;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.autoRotate)
        [self stopScroll];
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if(self.totalPages <= 1) return;
    CGFloat x = aScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self manualLoadData];
    }
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self manualLoadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    if(self.autoRotate&&self.totalPages>1)
        [self startRotate];
}
#pragma mark -clickHandle
- (void)handleTap:(UITapGestureRecognizer *)tap {
    self.block(self.curPage);
}
@end
