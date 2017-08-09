//
//  YWScrollerView.h
//  CustomCollectionLayout
//
//  Created by 天轩 on 2017/8/9.
//  Copyright © 2017年 天轩. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YWFlowLayout.h"
@class YWScrollerView;
@protocol YWScrollerViewDelegate <NSObject>

@required
/**
 数据操作方法
 */
-(__kindof UICollectionViewCell *)RegisterClassCell:(__kindof UICollectionViewCell *)RegisterCell cellForItemAtIndexPath:(NSIndexPath *)IndexPath;
/**
 设置列数
 */
-(NSInteger)numberOfColumsInYWscrollerView;
/**
 设置行数
 */
-(NSInteger)numberOfRowsInYWScrollerView;
@optional
/**
 点击方法
 */
-(void)YWScrollView:(YWScrollerView *)YWScroller didSelectItemForIndex:(NSIndexPath*)IndexPath;
@end
@interface YWScrollerView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 设置数据源
 */
@property(nonatomic,copy)NSMutableArray *dataSource;
/**
 暴露在外部，便于调用者设置其属性
 */
@property(nonatomic,strong)UIPageControl *pageControl;
/**
 设置代理属性
 */
@property(nonatomic,weak)id<YWScrollerViewDelegate>delegate;
/**
 是否展示pageCntroller
 */
@property(nonatomic,assign)BOOL isShowPage;
/**
 @parm 位置
 @parm 需要注册的Cell类，将此类暴露在外部即可随意定制内容
 @parm 是否时xib注册，不是请填写NO
 */
-(instancetype)initWithFrame:(CGRect)frame WithRegisterClass:(nullable Class)cell isXib:(BOOL)isXib;
/**
 手动更新
 */
-(void)reloadData;
/**
 更新self frame
 */
-(void)updateFrame:(CGRect)frame;
@end
