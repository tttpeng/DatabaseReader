//
//  ViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/19.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "ViewController.h"
#import "PTMultiColumnTableView.h"
#import <sqlite3.h>
#import "PTTableListViewController.h"

@interface ViewController ()<PTMultiColumnTableViewDataSource>
{
  sqlite3* _db;
}

@property (nonatomic, copy) NSString *databasePath;


@end

@implementation ViewController



- (void)viewDidLoad {
  
  
  [super viewDidLoad];
  
  
  self.view.backgroundColor = [UIColor grayColor];
  
  
  
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
  button.backgroundColor = [UIColor redColor];
  [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];

  
  
  PTTableListViewController *tableViewList = [[PTTableListViewController alloc] init];
  tableViewList.view.backgroundColor = [UIColor brownColor];
  [self.navigationController pushViewController:tableViewList animated:YES];
//  NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//  self.databasePath = [path stringByAppendingPathComponent:@"main.db"];
//  
//  [self createTestData];
//  [self displayDataInTableView];
//  self.view.backgroundColor = [UIColor grayColor];
}

- (void)click
{
  UIViewController *cc = [[UIViewController alloc] init];
  UIViewController *dd = [[UIViewController alloc] init];
  
//  dd.view.backgroundColor = [UIColor redColor];
  //  self.splitViewController.view.backgroundColor = [UIColor redColor];
//  //  [self.splitViewController addChildViewController:cc];
//  //  [self.splitViewController showViewController:cc sender:nil];
//  self.splitViewController.viewControllers = [NSArrayarrayWithObjects:cc, dd, nil];
  
  cc.view.backgroundColor = [UIColor greenColor];
    [self presentViewController:cc animated:YES completion:nil];
  
//  [self addChildViewController:dd];
  
  

  
}




//- (void)populateDatabase:(FMDatabase *)db
//{
//  [db executeUpdate:@"create table test (a text, b text, c integer, d double, e double)"];
//
//  [db beginTransaction];
//  int i = 0;
//  while (i++ < 20) {
//    [db executeUpdate:@"insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)" ,
//     @"hi'", // look!  I put in a ', and I'm not escaping it!
//     [NSString stringWithFormat:@"number %d", i],
//     [NSNumber numberWithInt:i],
//     [NSDate date],
//     [NSNumber numberWithFloat:2.2f]];
//  }
//  [db commit];
//
//  // do it again, just because
//  [db beginTransaction];
//  i = 0;
//  while (i++ < 20) {
//    [db executeUpdate:@"insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)" ,
//     @"hi again'", // look!  I put in a ', and I'm not escaping it!
//     [NSString stringWithFormat:@"number %d", i],
//     [NSNumber numberWithInt:i],
//     [NSDate date],
//     [NSNumber numberWithFloat:2.2f]];
//  }
//  [db commit];
//
//  [db executeUpdate:@"create table t3 (a somevalue)"];
//
//  [db beginTransaction];
//  for (int i=0; i < 20; i++) {
//    [db executeUpdate:@"insert into t3 (a) values (?)", [NSNumber numberWithInt:i]];
//  }
//  [db commit];
//}
//
//

@end
