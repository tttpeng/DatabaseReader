//
//  PTTableListViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/23.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "PTTableListViewController.h"
#import "PTDatabaseManager.h"
#import "PTTableContentViewController.h"

@interface PTTableListViewController ()
{
  PTDatabaseManager *_dbm;
}

@property (nonatomic, strong) NSArray *tables;

@end

@implementation PTTableListViewController




- (instancetype)init
{
  self = [super init];
  if (self) {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"main.db"];
    _dbm = [[PTDatabaseManager alloc] initWithPath:path];
    [_dbm open];
    [self getAllTables];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (void)getAllTables
{
  NSArray *resultArray = [_dbm queryAllTables];
  NSMutableArray *array = [NSMutableArray array];
  for (NSDictionary *dict in resultArray) {
    [array addObject:dict[@"name"]];
  }
  self.tables = array;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.tables.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
  cell.textLabel.text = self.tables[indexPath.row];
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PTTableContentViewController *contentViewController = [[PTTableContentViewController alloc] init];
  contentViewController.contensArray = [_dbm queryAllDataWithTableName:self.tables[indexPath.row]];

  contentViewController.columnsArray = [_dbm queryAllColumnsWithTableName:self.tables[indexPath.row]];
  NSLog(@"=------>%@",contentViewController.columnsArray);
  
  [self.navigationController pushViewController:contentViewController animated:YES];
}

@end
