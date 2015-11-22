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

static const CGFloat kColumnMargin = 1;

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


- (void)layoutSubviews
{
  [super layoutSubviews];
  
//  CGFloat width  = self.frame.size.width;
  CGFloat height = self.frame.size.height;
  
  CGFloat contentWidth = 0.0;
  NSInteger rowsCount = [self.dataSource numberOfColumnsInTableView:self];
  for (int i = 0; i < rowsCount; i++) {
    contentWidth += [self.dataSource multiColumnTableView:self widthForContentCellInColumn:i];
  }
  
  self.contentTableView.frame = CGRectMake(0, 0, contentWidth + [self numberOfColumns] * [self columnMargin] , height - 50);
  self.contentScrollView.contentSize = self.contentTableView.frame.size;
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
  for (int i = 0; i < [self numberOfColumns] ; i++) {
    w = [self contentWidthForColumn:i] + [self columnMargin];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w , 50)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w - [self columnMargin], 49)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [self.dataSource columnNameInColumn:i];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [self.headerScrollView addSubview:view];
    x = x + w;
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
    cell.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat x = 0.0;
    CGFloat w = 0.0;
    CGFloat h = [self contentHeightForRow:indexPath.row];
    for (int i = 0; i < [self numberOfColumns] ; i++) {
      w = [self contentWidthForColumn:i];

      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w , h - 1)];
      view.backgroundColor = [UIColor whiteColor];
      
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h - 1)];
      label.text = [self.dataSource contentAtColumn:i row:indexPath.row];
      [view addSubview:label];
      
      x = x + w + 1;
      
      if (i == [self.dataSource numberOfColumnsInTableView:self] - 1) {
        w += 1;
      }

      [cell.contentView addSubview:view];
    }
    return cell;
  }
  else {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [self.dataSource rowNameInRow:indexPath.row];
//    cell.backgroundColor = [self randomColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [self contentHeightForRow:indexPath.row] - 1, 100 , 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(99, 0, 1, [self contentHeightForRow:indexPath.row])];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:rightLine];
    [cell addSubview:line];
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
    self.headerScrollView.contentOffset = CGPointMake(self.contentScrollView.contentOffset.x, 0);
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



#pragma mark -
#pragma mark DataSource Accessor

- (NSInteger)numberOfrows
{
  return [self.dataSource numberOfRowsInTableView:self];
}

- (NSInteger)numberOfColumns
{
  return [self.dataSource numberOfColumnsInTableView:self];
}

- (NSString *)columnTitleForColumn:(NSInteger)column
{
  return [self.dataSource columnNameInColumn:column];
}

- (NSString *)rowTitleForRow:(NSInteger)row
{
  return [self.dataSource rowNameInRow:row];
}

- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row;
{
  return [self.dataSource contentAtColumn:column row:row];
}

- (CGFloat)contentWidthForColumn:(NSInteger)column
{
  return [self.dataSource multiColumnTableView:self widthForContentCellInColumn:column];
}

- (CGFloat)contentHeightForRow:(NSInteger)row
{
  return [self.dataSource multiColumnTableView:self heightForContentCellInRow:row];
}

- (CGFloat)columnMargin
{
  return kColumnMargin;
}

- (UIColor *)randomColor{
  
  CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

@end
