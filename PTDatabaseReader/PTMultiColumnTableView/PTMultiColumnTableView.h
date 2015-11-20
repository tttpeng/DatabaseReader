//
//  PTMultiColumnTableView.h
//  PTMultiColumnTableViewDemo
//
//  Created by Peng Tao on 15/11/16.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTMultiColumnTableView;
@protocol PTMultiColumnTableViewDataSource <NSObject>

@required


- (NSInteger)numberOfColumnsInTableView:(PTMultiColumnTableView *)tableView;
- (NSInteger)numberOfRowsInTableView:(PTMultiColumnTableView *)tableView;
- (NSString *)columnNameInColumn:(NSInteger)column;
- (NSString *)rowNameInRow:(NSInteger)row;
- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row;

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView widthForContentCellInColumn:(NSInteger)column;
- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView heightForContentCellInRow:(NSInteger)row;

@end


@interface PTMultiColumnTableView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<PTMultiColumnTableViewDataSource>dataSource;

- (void)reloadData;


@end
