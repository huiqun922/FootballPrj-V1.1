//
//  MainPageViewController.m
//  FootballPrj
//
//  Created by mokbid on 13-5-8.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "MainPageViewController.h"
#import "TheInfoViewController.h"
#import "MainPageFirstViewController.h"
#import "MainPageSecondViewController.h"
#import "MainPageThreeViewController.h"
#import "CaiWuViewController.h"
#import "AddTeamViewController.h"

@interface MainPageViewController ()
@property(nonatomic,retain)TheInfoViewController *theInfo;
@end

@implementation MainPageViewController
@synthesize theInfo;
@synthesize theTabBarVC;
@synthesize First,fuckday;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        if ([array count]<1) {
            First=YES;
        }else{
            First=NO;
        }
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"viewDidAppear");
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    if ([array count]<1) {
        First=YES;
        if(fuckday!=10086){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有属于您的球队，请先创建球队" delegate:self cancelButtonTitle:@"创建" otherButtonTitles:@"取消", nil];
            [alert show];
            [alert release];
        }
        

    }else{
        First=NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (iPhone5) {
        NSLog(@"iphone 5");
    }else{
        NSLog(@"iphone 4");
    }
    
    [self.theNavgation setTintColor:[UIColor clearColor]];
    [self.theNavgation setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(SelectTheInfo:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 44, 40)];
    self.theInfoButton=[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    UINavigationItem *theNavItem=[[UINavigationItem alloc] initWithTitle:@"草根足球管家"];
    theNavItem.rightBarButtonItem=self.theInfoButton;
    [self.theNavgation pushNavigationItem:theNavItem animated:NO];
    [theNavItem release];
    
    //球队管理
    MainPageFirstViewController *viewController1 =[[MainPageFirstViewController alloc] init];
   UINavigationController * nav1 =[[UINavigationController alloc] initWithRootViewController:viewController1];
    if (First) {
        viewController1.First=YES;
    }
    [viewController1 release];
    
    //比赛管理
    UIViewController *viewController2 = [[MainPageSecondViewController alloc] initWithNibName:@"MainPageSecondViewController" bundle:nil];
    UINavigationController * nav2 =[[UINavigationController alloc] initWithRootViewController:viewController2];
    [viewController2 release];
    //成员管理
    UIViewController *viewController3 = [[MainPageThreeViewController alloc] initWithNibName:@"MainPageThreeViewController" bundle:nil];
        UINavigationController * nav3 =[[UINavigationController alloc] initWithRootViewController:viewController3];
    [viewController3 release];
    //财务管理

    self.theTabBarVC = [[[UITabBarController alloc] init] autorelease];
    UIViewController *viewController5 = [[[CaiWuViewController alloc] initWithNibName:@"CaiWuViewController" bundle:nil] autorelease];
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:viewController5];
    
    self.theTabBarVC.viewControllers = [NSArray arrayWithObjects: nav1, nav2,nav3,nav,nil];
    [nav.navigationBar setTintColor:[UIColor clearColor]];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
    [nav1.navigationBar setTintColor:[UIColor clearColor]];
    [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
    [nav2.navigationBar setTintColor:[UIColor clearColor]];
    [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
    [nav3.navigationBar setTintColor:[UIColor clearColor]];
    [nav3.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
   [nav1 release];
   [nav release];
   [nav2 release];
   [nav3 release];
    
    [self.theTabBarVC.view setFrame:[[UIScreen mainScreen] bounds]];
    [self.theTabBarVC.tabBar setTintColor:[UIColor clearColor]];
    [self.theTabBarVC.tabBar setBackgroundImage:[UIImage imageNamed:@"底部导航条.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SelectTheInfo:(UIBarButtonItem *)sender {
    TheInfoViewController *inforView=[[TheInfoViewController alloc] initWithNibName:@"TheInfoViewController" bundle:nil];
    self.theInfo=inforView;
    [inforView release];
    [self presentViewController:self.theInfo animated:YES completion:nil];
    
}

- (IBAction)MyTeam:(id)sender{
    if (First) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有属于您的球队，请先创建球队" delegate:self cancelButtonTitle:@"创建" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
        return ;
    }
    self.theTabBarVC.selectedIndex=0;
    [self presentModalViewController:self.theTabBarVC animated:YES];
}

- (IBAction)FootGame:(id)sender {
    if (First) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有属于您的球队，请先创建球队" delegate:self cancelButtonTitle:@"创建" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
        return ;
    }
    
    self.theTabBarVC.selectedIndex=1;
    [self presentModalViewController:self.theTabBarVC animated:YES];
}

- (IBAction)TeamMember:(id)sender {
    if (First) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有属于您的球队，请先创建球队" delegate:self cancelButtonTitle:@"创建" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
        return ;
    }
        self.theTabBarVC.selectedIndex=2;
        [self presentModalViewController:self.theTabBarVC animated:YES];
}

- (IBAction)Finance:(id)sender {
    if (First) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有属于您的球队，请先创建球队" delegate:self cancelButtonTitle:@"创建" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
        return ;
    }
    
        self.theTabBarVC.selectedIndex=3;
        [self presentModalViewController:self.theTabBarVC animated:YES];
}
//UIAlertView 委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.theTabBarVC.selectedIndex=0;
        [self presentModalViewController:self.theTabBarVC animated:YES];
        
    }else{
        NSLog(@"cacnle");
    }
}
- (void)dealloc {
    [theInfo release];
    [theTabBarVC release];
    [_theNavgation release];
    [_theInfoButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheNavgation:nil];
    [self setTheInfoButton:nil];
    [super viewDidUnload];
}
-(void)showALert{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有属于您的球队，请先创建球队" delegate:self cancelButtonTitle:@"创建" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];}
@end
