//
//  PTMultiColumnTableView.m
//  PTMultiColumnTableViewDemo
//
//  Created by Peng Tao on 15/11/16.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "PTMultiColumnTableView.h"

@interface PTMultiColumnTableView ()
<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *headerScrollView;
@property (nonatomic, strong) UITableView  *leftTableView;
@property (nonatomic, strong) UITableView  *contentTableView;
@end

@implementation PTMultiColumnTableView


- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    [self loadHeaderScrollView];
    [self loadContentScrollView];
    [self loadLeftView];
  }
  return self;
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  [self reloadData];
  
}

- (void)reloadData
{
  [self loadHeaderData];
  [self loadLeftViewData];
  [self loadContentData];
}


#pragma mark - UI

- (void)loadHeaderScrollView
{
  UIScrollView *headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 0, self.frame.size.width - 100, 50)];
  headerScrollView.backgroundColor = [UIColor brownColor];
  headerScrollView.contentSize = CGSizeMake(2000, 50);
  headerScrollView.delegate = self;
  [self addSubview:headerScrollView];
  self.headerScrollView = headerScrollView;
}

- (void)loadContentScrollView
{
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 50, self.frame.size.width - 50, self.frame.size.height - 50)];
  scrollView.bounces = NO;
  [self addSubview:scrollView];
  scrollView.delegate = self;
  UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 2000, scrollView.frame.size.height)];
  tableView.delegate = self;
  tableView.dataSource = self;
  tableView.bounces = NO;
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.contentTableView = tableView;
  [scrollView addSubview:tableView];
  scrollView.contentSize = tableView.frame.size;
  self.contentScrollView = scrollView;
  
}

- (void)loadLeftView
{
  UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 100, self.contentScrollView.contentSize.height)];
  leftTableView.backgroundColor = [UIColor cyanColor];
  
  leftTableView.delegate = self;
  leftTableView.dataSource = self;
  [self addSubview:leftTableView];
  self.leftTableView = leftTableView;
}


#pragma mark - Data

- (void)loadHeaderData
{
  NSArray *subviews = self.headerScrollView.subviews;
  
  for (UIView *subview in subviews) {
    [subview removeFromSuperview];
  }
  CGFloat x = 0.0;
  CGFloat w = 0.0;
  for (int i = 0; i < [self.dataSource numberOfColumnsInTableView:self] ; i++) {
    w = [self.dataSource multiColumnTableView:self heightForContentCellInRow:i];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w , 50)];
    view.backgroundColor = [self randomColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 49)];
    label.text = [self.dataSource columnNameInColumn:i];
    label.backgroundColor = [UIColor redColor];
    [view addSubview:label];
    [self.headerScrollView addSubview:view];
    x = x + w + 1;
    NSLog(@"-----%f-->%f",w,x);
  }
}

- (void)loadContentData
{
  [self.contentTableView reloadData];
}

- (void)loadLeftViewData
{
  [self.leftTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView != self.leftTableView) {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor grayColor];
    
    CGFloat x = 0.0;
    CGFloat w = 0.0;
    CGFloat h = [self.dataSource multiColumnTableView:self heightForContentCellInRow:indexPath.row];
    for (int i = 0; i < [self.dataSource numberOfColumnsInTableView:self] ; i++) {
      w = [self.dataSource multiColumnTableView:self heightForContentCellInRow:i];
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w , h - 1)];
      view.backgroundColor = [UIColor whiteColor];
      
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h - 1)];
      label.text = [self.dataSource contentAtColumn:i row:indexPath.row];
      [view addSubview:label];
      
      x = x + w + 1;
      [cell.contentView addSubview:view];
    }
    return cell;
  }
  else {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [self.dataSource rowNameInRow:indexPath.row];
    cell.backgroundColor = [self randomColor];
    return cell;
    
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.dataSource numberOfRowsInTableView:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.dataSource multiColumnTableView:self heightForContentCellInRow:indexPath.row];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView == self.contentScrollView) {
    self.headerScrollView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.headerScrollView) {
    self.contentScrollView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.leftTableView) {
    self.contentTableView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.contentTableView) {
    self.leftTableView.contentOffset = scrollView.contentOffset;
  }
}

- (UIColor *)randomColor{
  
  CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

@end
