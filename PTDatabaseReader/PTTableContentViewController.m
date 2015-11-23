//
//  PTTableContentViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/23.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "PTTableContentViewController.h"
#import "PTMultiColumnTableView.h"


@interface PTTableContentViewController ()<PTMultiColumnTableViewDataSource>

@property (nonatomic, strong)PTMultiColumnTableView *multiColumView;

@end

@implementation PTTableContentViewController


- (instancetype)init
{
  self = [super init];
  if (self) {
    _multiColumView = [[PTMultiColumnTableView alloc] initWithFrame:CGRectMake(0, 64, 1024, 700)];
    _multiColumView.backgroundColor = [UIColor whiteColor];
    _multiColumView.dataSource = self;
    [self.view addSubview:_multiColumView];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.multiColumView reloadData];
  
}
- (NSInteger)numberOfColumnsInTableView:(PTMultiColumnTableView *)tableView
{
  return self.columnsArray.count;
}
- (NSInteger)numberOfRowsInTableView:(PTMultiColumnTableView *)tableView
{
  return self.contensArray.count;
}


- (NSString *)columnNameInColumn:(NSInteger)column
{
    NSLog(@"----->%@",self.columnsArray);
    return self.columnsArray[column];
}


- (NSString *)rowNameInRow:(NSInteger)row
{
  
  return [NSString stringWithFormat:@"%ld",(long)row];
  
}
- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row
{
  NSLog(@"12----->%@",self.columnsArray);
  if (self.contensArray.count > row) {
    NSDictionary *dic = self.contensArray[row];
    if (self.contensArray.count > column) {
      return [NSString stringWithFormat:@"%@",[dic objectForKey:self.columnsArray[column]]];
    }
  }
  return @"xxxxx";
}

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView
      heightForContentCellInRow:(NSInteger)row
{
  return 40;
}

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView
    widthForContentCellInColumn:(NSInteger)column
{
  return 100;
}


- (CGFloat)heightForTopHeaderInTableView:(PTMultiColumnTableView *)tableView
{
  return 50;
}

- (CGFloat)WidthForLeftHeaderInTableView:(PTMultiColumnTableView *)tableView
{
  return 80;
}


@end
