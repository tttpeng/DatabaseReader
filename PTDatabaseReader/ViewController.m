//
//  ViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/19.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

#import "PTMultiColumnTableView.h"

@interface ViewController ()<PTMultiColumnTableViewDataSource>

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSArray *columnsArray;
@property (nonatomic, strong) NSArray *contensArray;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createTestData];
  [self selectAllInfo];
  
  
}

- (void)createTestData
{
  
  NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

  FMDatabase *db = [FMDatabase databaseWithPath:[path stringByAppendingPathComponent:@"main.db"]];
  _db = db;
  [_db open];
//  [self populateDatabase:db];
  
}

- (void)displayDataInTableView
{
  
  PTMultiColumnTableView *multiColumView = [[PTMultiColumnTableView alloc] initWithFrame:self.view.frame];
  multiColumView.dataSource = self;
  [self.view addSubview:multiColumView];
  
  
  
}

- (void)selectAllInfo
{
  
  NSMutableArray *allTables = [NSMutableArray array];
  
  FMResultSet *tableRs = [_db executeQueryWithFormat:@"select name from sqlite_master where type='table' order by name"];
  
  while ([tableRs next]) {
    NSDictionary *d = [tableRs resultDictionary];
    NSLog(@"tables --------- %@",d);
    [allTables addObject:d[@"name"]];
  };
  
  NSMutableArray *columns = [NSMutableArray array];
  
  NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info('%@')",allTables[1]];

  FMResultSet *rs = [_db executeQuery:sql];
  NSLog(@"--->%@",rs.query);
  while ([rs next]) {
    NSDictionary *d = [rs resultDictionary];
    NSLog(@"%@",d[@"name"]);
    [columns addObject:d[@"name"]];
  }
  
  self.columnsArray = columns;
  
  NSMutableArray *content  = [NSMutableArray array];
  NSString *sql2 = [NSString stringWithFormat:@"SELECT * FROM %@",allTables[1]];
  FMResultSet *contentRs = [_db executeQueryWithFormat:sql2];
  while ([contentRs next]) {
    NSDictionary *d = [contentRs resultDictionary];
    [content addObject:d];
    NSLog(@"%@",d);
  }
  
  self.contensArray = content;
  
  [self displayDataInTableView];
  
  
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
  return self.columnsArray[column];
}
- (NSString *)rowNameInRow:(NSInteger)row
{
  
  return [NSString stringWithFormat:@"%ld",(long)row];
  
}
- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row
{
  if (self.contensArray.count > row) {
    NSDictionary *dic = self.contensArray[row];
    if (self.contensArray.count > column) {
      NSLog(@"----######--->%@",self.columnsArray[column]);
      NSLog(@"---------->>%@",dic);
        return [NSString stringWithFormat:@"%@",[dic objectForKey:self.columnsArray[column]]];
    }
  }
  return @"xxxxxxx";
  
  
  
}

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView heightForContentCellInRow:(NSInteger)row
{
  return 100;
}

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView widthForContentCellInColumn:(NSInteger)column
{
  return 100;
}



@end
