//
//  YFShadeNavBarViewController.m
//  YFNavigationbarDemo
//
//  Created by MissYoung on 16/12/9.
//  Copyright © 2016年 Fanny. All rights reserved.
//

#import "YFShadeNavBarViewController.h"
#import "UINavigationBar+Awesome.h"

#define NAVBAR_CHANGE_POINT 50

static NSString * const kCellId = @"Cell_ID";

@interface YFShadeNavBarViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation YFShadeNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"渐变";
    
    _tableView.tableHeaderView = self.headerView;
    
    // respondsToSelector: 用来判断是否有以某个名字命名的方法(被封装在一个selector的对象里传递)
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;// 设置scrollView从(0,0)点开始
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
    
    // 还原一下颜色
    [self updateNavigationBarItemColorWithColor:[UIColor blackColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark -- UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    cell.textLabel.text = @"嘻嘻嘻";
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self updateNavigationBarItemColorWithColor:[UIColor whiteColor]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self updateNavigationBarItemColorWithColor:[UIColor blackColor]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void) updateNavigationBarItemColorWithColor:(UIColor *)color
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = color;
}

#pragma mark -- private methods
#pragma mark -- initial views
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSreenWidth, 210)];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, _headerView.height)];
        [img setImage:[UIImage imageNamed:@"headerImg"]];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img setClipsToBounds:YES];
        [_headerView addSubview:img];
    }
    
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
