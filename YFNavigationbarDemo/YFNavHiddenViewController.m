//
//  YFNavHiddenViewController.m
//  YFNavigationbarDemo
//
//  Created by MissYoung on 16/12/9.
//  Copyright © 2016年 Fanny. All rights reserved.
//

#import "YFNavHiddenViewController.h"
#import "UINavigationBar+Awesome.h"

typedef NS_ENUM(NSInteger, YFHiddenTYpe) {
    YFHiddenTYpeOne, // 隐藏方式1:使用scrollViewWillEndDragging的UIScrollViewDelegate方法
                     // (效果不好，当向上滑动时手不离开时，不会隐藏导航栏；或者手指不离开缓慢滑动后停下，导航栏也不隐藏)
    YFHiddenTYpeTwo, // 隐藏方式2:设置self.navigationController.hidesBarsOnSwipe = YES
                     // (效果较方式1好些，但是当手指不离开缓慢向下滑动后停下，导航栏不显示出来，而且滑动会tableview中的内容会和状态栏重合)
    YFHiddenTYpeThree, // 隐藏方式3:使用scrollViewDidScroll的UIScrollViewDelegate方法
                       // (效果较上两种好，但隐藏速度太快，稍微滑动一点导航栏就隐藏了)
    YFHiddenTYpeFour   // 隐藏方式4:使用scrollViewDidScroll的UIScrollViewDelegate方法
                       // (使用UINavigationBar+Awesome，效果较前三种好)
};

static NSString * const kCellId = @"Cell_ID";

@interface YFNavHiddenViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (nonatomic, assign) YFHiddenTYpe hiddType;
@end

@implementation YFNavHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"隐藏";
    
    _hiddType = YFHiddenTYpeFour;
    
    if (_hiddType == YFHiddenTYpeOne || _hiddType == YFHiddenTYpeThree) {
        // respondsToSelector: 用来判断是否有以某个名字命名的方法(被封装在一个selector的对象里传递)
        if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
            UIEdgeInsets insets = self.tableView.contentInset;
            insets.top = self.navigationController.navigationBar.bounds.size.height;
            self.tableView.contentInset = insets;
            self.tableView.scrollIndicatorInsets = insets; // 状态条和scrollView边距的距离
        }
        
        _tableViewTop.constant = 20;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (_hiddType == YFHiddenTYpeTwo) {
        self.navigationController.hidesBarsOnSwipe = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    switch (_hiddType) {
        case YFHiddenTYpeOne:
        {
            self.navigationController.navigationBarHidden = NO;
            break;
        }
        case YFHiddenTYpeTwo:
        {
            self.navigationController.hidesBarsOnSwipe = NO;
            break;
        }
        case YFHiddenTYpeThree:
        {
            break;
        }
        case YFHiddenTYpeFour:
        {
            [self.navigationController.navigationBar lt_reset];
            break;
        }
        default:
            break;
    }
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
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}


#pragma mark -- 隐藏显示导航栏方式1
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_hiddType == YFHiddenTYpeOne) {
        if(velocity.y > 0) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}

#pragma mark -- 隐藏显示导航栏方式3/4
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     if (_hiddType == YFHiddenTYpeThree) {
         //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
         UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
         //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
         CGFloat velocity = [pan velocityInView:scrollView].y;
         
         if (velocity <- 5) {
             //向上拖动，隐藏导航栏
             [self.navigationController setNavigationBarHidden:YES animated:YES];
         }else if (velocity > 5) {
             //向下拖动，显示导航栏
             [self.navigationController setNavigationBarHidden:NO animated:YES];
         }else if(velocity == 0){
             //停止拖拽
         }
     } else if (_hiddType == YFHiddenTYpeFour) {
         CGFloat offsetY = scrollView.contentOffset.y;
         if (offsetY > 0) {
             if (offsetY >= 44) {
                 [self setNavigationBarTransformProgress:1];
             } else {
                 [self setNavigationBarTransformProgress:(offsetY / 44)];
             }
         } else {
             [self setNavigationBarTransformProgress:0];
             self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
         }
     }
    
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
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
