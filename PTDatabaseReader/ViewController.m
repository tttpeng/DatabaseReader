//
//  ViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/19.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "ViewController.h"
#import "PTTableListViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *databasePath;


@end

@implementation ViewController



- (void)viewDidLoad {
  
  
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor grayColor];
  
  PTTableListViewController *tableViewList = [[PTTableListViewController alloc] init];
  tableViewList.view.backgroundColor = [UIColor brownColor];
  [self.navigationController pushViewController:tableViewList animated:YES];
}



@end
