//
//  YWScrollerView.m
//  CustomCollectionLayout
//
//  Created by 天轩 on 2017/8/9.
//  Copyright © 2017年 天轩. All rights reserved.
//
#import "YWScrollerView.h"
/************************YWFlowLayout**************************/
@class YWFlowLayout;
@protocol YWFlowLayoutDelegate <NSObject>

@required
/**
 行数
 */
-(NSInteger)numberOfRowsInYWLayout:(YWFlowLayout *)YWLayout;
/**
 设置列数
 @parm 当数据源个数低于计算数目时
 此方法自动失效
 会以最合适的高度设置
 */
-(NSInteger)numberOfColumsInYWLayout:(YWFlowLayout *)YWLayout;

@end

@interface YWFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,weak)id <YWFlowLayoutDelegate>delegate;
@property(nonatomic,readonly)NSInteger row;
@property(nonatomic,readonly)NSInteger colum;
@end

@implementation YWFlowLayout

-(void)prepareLayout
{
    //    准备方法被自动调用，以保证layout实例的正确。
    [super prepareLayout];
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.bounces=NO;
    self.collectionView.pagingEnabled=YES;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(numberOfColumsInYWLayout:)])
    {
        _colum=[self.delegate numberOfColumsInYWLayout:self];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(numberOfRowsInYWLayout:)])
    {
        _row=[self.delegate numberOfRowsInYWLayout:self];
    }
    NSAssert(_row!=0&&_colum!=0, @"这样还有什么意思呢？行数和列数不能为0");
    /*
     当设置数量不正确时，我们自动给取合适的高度
     */
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (itemCount<(_row*_colum))
    {
        _row=(itemCount%_colum==0?itemCount/_colum:itemCount/_colum+1);
    }
    
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //.返回rect中的所有的元素的布局属性
    NSInteger numCount = [self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *array=[NSMutableArray new];
    for (int i =0; i<numCount; i++)
    {
        UICollectionViewLayoutAttributes *att=[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [array addObject:att];
    }
    return array;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger rows = _row;
    NSInteger colum = _colum;
    NSInteger page = indexPath.item/(rows * colum);
    /*
     计算间距
     */
    //    CGFloat cellW =(self.collectionView.bounds.size.width -self.sectionInset.left - self.sectionInset.right - (colum - 1) * self.minimumInteritemSpacing)/colum;
    /*
     不计算间距
     */
    CGFloat cellW=self.collectionView.bounds.size.width/colum;
    
    NSInteger  itemRow = (indexPath.item - page*(colum*rows))/ colum;//行数
    NSInteger itemCol = (indexPath.item - page*(colum*rows))% colum;//列数
    CGFloat cellX = page * self.collectionView.bounds.size.width + itemCol * (cellW) + self.sectionInset.left;
    /*
     同上
     */
    //    CGFloat cellH = (self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - (rows - 1) * self.minimumLineSpacing) / rows;
    CGFloat cellH =self.collectionView.bounds.size.height/rows;
    CGFloat cellY = itemRow * (cellH + self.sectionInset.top) + self.sectionInset.top;
    attr.frame =CGRectMake(cellX, cellY, cellW, cellH);
    //    返回对应于indexPath的位置的cell的布局属性
    return attr;
}
-(CGSize)collectionViewContentSize
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger page =itemCount%(_colum*_row)==0? itemCount/(_colum*_row):
    itemCount/(_colum*_row)+1;
    return CGSizeMake(self.collectionView.bounds.size.width*page, self.collectionView.frame.size.height);
}
@end

/************************YWScrollerView**************************/
@interface YWScrollerView()<YWFlowLayoutDelegate>
@property(nonatomic,strong)Class RegisterCell;
@property(nonatomic,strong)UICollectionView *YWCollection;
@property(nonatomic,assign)BOOL isXib;
@property(nonatomic,readonly,assign)NSInteger colum;
@property(nonatomic,readonly,assign)NSInteger rows;
@property(nonatomic,assign)CGRect react;
@end
@implementation YWScrollerView
-(instancetype)initWithFrame:(CGRect)frame WithRegisterClass:(nullable Class)cell isXib:(BOOL)isXib
{
    if (self=[super initWithFrame:frame])
    {
        self.RegisterCell=cell;
        self.isXib=isXib;
        _react=frame;
        [self creatUI:frame];
        
    }
    return self;
}
-(void)creatUI:(CGRect)frame
{
    self.userInteractionEnabled=YES;
    YWFlowLayout *Layout=[[YWFlowLayout alloc]init];
    Layout.delegate=self;
    _YWCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:Layout];
    _YWCollection.backgroundColor=[UIColor grayColor];
    _YWCollection.delegate=self;
    _YWCollection.dataSource=self;
    [self addSubview:_YWCollection];
    if (_isXib==YES)
    {
        [_YWCollection registerNib:[UINib nibWithNibName:NSStringFromClass(_RegisterCell) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(self.RegisterCell)];
    }else
    {
     [_YWCollection registerClass:_RegisterCell forCellWithReuseIdentifier:NSStringFromClass(_RegisterCell)];
    }
}
#pragma mark-UICollection-datasoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource)
    {
        return self.dataSource.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(_RegisterCell) forIndexPath:indexPath];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(RegisterClassCell:cellForItemAtIndexPath:)]) {
          cell= [self.delegate RegisterClassCell:cell cellForItemAtIndexPath:indexPath];
        }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(YWScrollView:didSelectItemForIndex:)]) {
        [self.delegate YWScrollView:self didSelectItemForIndex:indexPath];
    }
    
}
#pragma mark-FlowLayout delegate
-(NSInteger)numberOfColumsInYWLayout:(YWFlowLayout *)YWLayout
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(numberOfColumsInYWscrollerView)])
    {
        
         _colum= [self.delegate numberOfColumsInYWscrollerView];
        return _colum;
    }
    return _colum;
}
-(NSInteger)numberOfRowsInYWLayout:(YWFlowLayout *)YWLayout
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(numberOfRowsInYWScrollerView)])
    {
        _rows=[self.delegate numberOfRowsInYWScrollerView];
        
        return _rows;
    }
    return _rows;
}
-(void)reloadData
{
    [_YWCollection reloadData];
}
-(void)updateFrame:(CGRect)frame
{
    _YWCollection.frame=frame;
    [self reloadData];
}
-(void)setIsShowPage:(BOOL)isShowPage
{
    _isShowPage=isShowPage;
    _YWCollection.frame=CGRectMake(0, 0, _react.size.width, _react.size.height-20);
    if (!_pageControl)
    {
        [self creatPageController];
    }
}
-(void)creatPageController
{
    NSInteger itemCount=[_YWCollection numberOfItemsInSection:0];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(numberOfRowsInYWScrollerView)])
    {
        _rows=[self.delegate numberOfRowsInYWScrollerView];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(numberOfColumsInYWscrollerView)])
    {
        _colum= [self.delegate numberOfColumsInYWscrollerView];
    }
    NSInteger page =itemCount%(_colum*_rows)==0? itemCount/(_colum*_rows):
    itemCount/(_colum*_rows)+1;
    _pageControl= [[UIPageControl alloc] init];
    _pageControl.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-120/2, CGRectGetHeight(_YWCollection.frame), 120, 20);
    _pageControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _pageControl.numberOfPages =page;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor clearColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:_pageControl];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage=scrollView.contentOffset.x/CGRectGetWidth(_YWCollection.frame);
}
@end
