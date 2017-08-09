//
//  ViewController.m
//  CustomCollectionLayout
//
//  Created by 天轩 on 2017/8/9.
//  Copyright © 2017年 天轩. All rights reserved.
//

#import "ViewController.h"
#import "YWScrollerView.h"
#import "MyCollectionViewCell.h"
@interface ViewController ()<YWScrollerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *textArr=[NSMutableArray new];
    for (int i=0; i<18; i++)
    {
        [textArr addObject:@"qwe"];
    }
    YWScrollerView *scroll=[[YWScrollerView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200) WithRegisterClass:[MyCollectionViewCell class] isXib:YES];
    scroll.delegate=self;
    scroll.dataSource=textArr;
    [self.view addSubview:scroll];
    scroll.isShowPage=YES;
}
-(void)YWScrollView:(YWScrollerView *)YWScroller didSelectItemForIndex:(NSIndexPath *)IndexPath
{

}
-(NSInteger)numberOfRowsInYWScrollerView
{
    return 2;
}
-(NSInteger)numberOfColumsInYWscrollerView
{
    return 3;
}
-(UICollectionViewCell *)RegisterClassCell:(__kindof UICollectionViewCell *)RegisterCell cellForItemAtIndexPath:(NSIndexPath *)IndexPath
{
   
    
    
    return RegisterCell;
}
@end
