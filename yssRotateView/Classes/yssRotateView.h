//
//  yssRotateView.h
//  Pods
//
//  Created by maoer on 2016/12/5.
//
//

#import <UIKit/UIKit.h>
typedef void(^yssRotateViewClickIndexBlock)(NSInteger index);
typedef void(^yssBindCellDataIndexBlock)(UIView*v,NSInteger index);
@interface yssRotateView : UIView

/**
 RotateView的参数介绍
 @param frame       frame
 @param cellViewClass                 cell的class类型
 @param autoRotate                    是否自动旋转
 @param idleTime                      每个cell停留时间
 @param pageIndicatorTintColor        pageCotrol的颜色
 @param currentPageIndicatorTintColor pageControl选中时候的颜色
 @param handle                        点击时候的操作block
 
 @return <#return value description#>
 */
-(instancetype)initWithCellViewClass:(Class)cellViewClass
                          autoRotate:(BOOL)autoRotate
                            idleTime:(CGFloat)idleTime
              pageIndicatorTintColor:(UIColor*)pageIndicatorTintColor
       currentPageIndicatorTintColor:(UIColor*)currentPageIndicatorTintColor
                pageContrlFromBottom:(CGFloat)pageContrlFromBottom
                   pageControlHeight:(CGFloat)pageControlHeight
                    clickIndexHandle:(yssRotateViewClickIndexBlock)handle;
/**
 <#Description#>
 
 @param count         cell的个数
 @param bindDataBlock 具体的绑定block
 */
-(void) bindCellDataWithcellsCount:(NSInteger)count bindCellDataHandle:(yssBindCellDataIndexBlock)bindDataBlock;

@end

