//
//  ViewController.m
//  YFNavigationbarDemo
//
//  Created by MissYoung on 16/12/8.
//  Copyright © 2016年 Fanny. All rights reserved.
//

#import "ViewController.h"
#import "YFNavHiddenViewController.h"
#import "YFTransparenceNavBarViewController.h"
#import "YFShadeNavBarViewController.h"

static NSString * const kCellId = @"Cell_ID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *controllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"菜单";
    
    _dataSourceArray = [NSMutableArray array];
    [_dataSourceArray addObject:@"滑动隐藏导航栏"];
    [_dataSourceArray addObject:@"全透明导航栏"];
    [_dataSourceArray addObject:@"渐变导航栏"];
    
    _controllers = [NSMutableArray array];
    [_controllers addObject: [[YFNavHiddenViewController alloc] initWithNibName:@"YFNavHiddenViewController" bundle:nil]];
    [_controllers addObject:[[YFTransparenceNavBarViewController alloc] initWithNibName:@"YFTransparenceNavBarViewController" bundle:nil]];
    [_controllers addObject:[[YFShadeNavBarViewController alloc] initWithNibName:@"YFShadeNavBarViewController" bundle:nil]];
}


#pragma mark -- UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:_controllers[indexPath.row] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
