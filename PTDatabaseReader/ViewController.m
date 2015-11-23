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

@interface ViewController ()<PTMultiColumnTableViewDataSource>
{
  sqlite3* _db;
}
@property (nonatomic, strong) NSArray *columnsArray;
@property (nonatomic, strong) NSArray *contensArray;

@property (nonatomic, copy) NSString *databasePath;

@end

@implementation ViewController

static NSString *const QUERY_TABLENAMES_SQL = @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";


- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  self.databasePath = [path stringByAppendingPathComponent:@"main.db"];
  
  [self createTestData];
  [self displayDataInTableView];
  
  self.view.backgroundColor = [UIColor grayColor];
}


- (BOOL)open {
  if (_db) {
    return YES;
  }
  int err = sqlite3_open([self.databasePath UTF8String], &_db);
  if(err != SQLITE_OK) {
    NSLog(@"error opening!: %d", err);
    return NO;
  }
  return YES;
}

- (void)createTestData
{
  [self open];
  NSArray *array = [self executeQuery:QUERY_TABLENAMES_SQL];
  NSLog(@"all tables: -->%@",array);
  
  NSArray *allColumns = [self queryAllColumnsWithTableName:array[1][@"name"]];
  NSArray *allData    = [self queryAllDataWithTableName:array[1][@"name"]];
  
  NSMutableArray *dataArray  = [NSMutableArray array];
  for (NSDictionary *dict in allColumns) {
    [dataArray addObject:dict[@"name"]];
  }
  self.columnsArray = dataArray;
  self.contensArray = allData;
  NSLog(@"所有的列 ：--->%@",allColumns);
  NSLog(@"所有的数据：--->%@",allData);
}

- (NSArray *)executeQuery:(NSString *)sql
{
  NSMutableArray *resultArray = [NSMutableArray array];
  [self open];
  sqlite3_stmt *pstmt;
  if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &pstmt, 0) == SQLITE_OK) {
    while (sqlite3_step(pstmt) == SQLITE_ROW) {
      NSUInteger num_cols = (NSUInteger)sqlite3_data_count(pstmt);
      if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        int columnCount = sqlite3_column_count(pstmt);
        
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
          
          NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(pstmt, columnIdx)];
          id objectValue = [self objectForColumnIndex:columnIdx stmt:pstmt];
          [dict setObject:objectValue forKey:columnName];
        }
        [resultArray addObject:dict];
      }
    }
  }
  return resultArray;
}

- (NSArray *)queryAllColumnsWithTableName:(NSString *)tableName
{
  NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info('%@')",tableName];
  return [self executeQuery:sql];
}

- (NSArray *)queryAllDataWithTableName:(NSString *)tableName
{
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
  return [self executeQuery:sql];
}

- (id)objectForColumnIndex:(int)columnIdx stmt:(sqlite3_stmt*)stmt {
  int columnType = sqlite3_column_type(stmt, columnIdx);
  
  id returnValue = nil;
  
  if (columnType == SQLITE_INTEGER) {
    returnValue =  [NSNumber numberWithLongLong:sqlite3_column_int64(stmt, columnIdx)];
  }
  else if (columnType == SQLITE_FLOAT) {
    returnValue = [NSNumber numberWithDouble:sqlite3_column_double(stmt, columnIdx)];
  }
  else if (columnType == SQLITE_BLOB) {
    returnValue = [self dataForColumnIndex:columnIdx stmt:stmt];
  }
  else {
    //default to a string for everything else
    returnValue = [self stringForColumnIndex:columnIdx stmt:stmt];
  }
  
  if (returnValue == nil) {
    returnValue = [NSNull null];
  }
  
  return returnValue;
}

- (NSString*)stringForColumnIndex:(int)columnIdx stmt:(sqlite3_stmt *)stmt {
  
  if (sqlite3_column_type(stmt, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
    return nil;
  }
  
  const char *c = (const char *)sqlite3_column_text(stmt, columnIdx);
  
  if (!c) {
    // null row.
    return nil;
  }
  
  return [NSString stringWithUTF8String:c];
}

- (NSData*)dataForColumnIndex:(int)columnIdx stmt:(sqlite3_stmt *)stmt{
  
  if (sqlite3_column_type(stmt, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
    return nil;
  }
  
  const char *dataBuffer = sqlite3_column_blob(stmt, columnIdx);
  int dataSize = sqlite3_column_bytes(stmt, columnIdx);
  
  if (dataBuffer == NULL) {
    return nil;
  }
  
  return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}

- (void)displayDataInTableView
{
  PTMultiColumnTableView *multiColumView = [[PTMultiColumnTableView alloc] initWithFrame:CGRectMake(100, 100, 400, 400)];
  multiColumView.dataSource = self;
  [self.view addSubview:multiColumView];
  
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
  NSLog(@"----->%@",self.columnsArray[column]);
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
      return [NSString stringWithFormat:@"%@",[dic objectForKey:self.columnsArray[column]]];
    }
  }
  return @"xxxxx";
}

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView heightForContentCellInRow:(NSInteger)row
{
  return 40;
}

- (CGFloat)multiColumnTableView:(PTMultiColumnTableView *)tableView widthForContentCellInColumn:(NSInteger)column
{
  return 100;
}


- (CGFloat)heightForTopHeaderInTableView:(PTMultiColumnTableView *)tableView
{
  return 50;
}

- (CGFloat)WidthForLeftHeaderInTableView:(PTMultiColumnTableView *)tableView
{
  return 50;
}

@end
