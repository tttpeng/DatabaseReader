//
//  ViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/19.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createTestData];
  
  
}

- (void)createTestData
{
  
  NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

  FMDatabase *db = [FMDatabase databaseWithPath:[path stringByAppendingPathComponent:@"main.db"]];
  
  [db open];
  [self populateDatabase:db];
}

- (void)populateDatabase:(FMDatabase *)db
{
  [db executeUpdate:@"create table test (a text, b text, c integer, d double, e double)"];
  
  [db beginTransaction];
  int i = 0;
  while (i++ < 20) {
    [db executeUpdate:@"insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)" ,
     @"hi'", // look!  I put in a ', and I'm not escaping it!
     [NSString stringWithFormat:@"number %d", i],
     [NSNumber numberWithInt:i],
     [NSDate date],
     [NSNumber numberWithFloat:2.2f]];
  }
  [db commit];
  
  // do it again, just because
  [db beginTransaction];
  i = 0;
  while (i++ < 20) {
    [db executeUpdate:@"insert into test (a, b, c, d, e) values (?, ?, ?, ?, ?)" ,
     @"hi again'", // look!  I put in a ', and I'm not escaping it!
     [NSString stringWithFormat:@"number %d", i],
     [NSNumber numberWithInt:i],
     [NSDate date],
     [NSNumber numberWithFloat:2.2f]];
  }
  [db commit];
  
  [db executeUpdate:@"create table t3 (a somevalue)"];
  
  [db beginTransaction];
  for (int i=0; i < 20; i++) {
    [db executeUpdate:@"insert into t3 (a) values (?)", [NSNumber numberWithInt:i]];
  }
  [db commit];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
