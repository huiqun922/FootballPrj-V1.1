//
//  TheInfoViewController.m
//  FootballPrj
//
//  Created by mokbid on 13-5-8.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "TheInfoViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#import "MainPageAppDelegate.h"
#import "MainPageAppDelegate.h"
#import "AboutUsViewController.h"
#import "HelpViewController.h"
#import "FTAnimation.h"


#define ACTION_SHEET_GET_USER_INFO 200
#define ACTION_SHEET_FOLLOW_USER 201
#define ACTION_SHEET_GET_OTHER_USER_INFO 202
#define ACTION_SHEET_GET_ACCESS_TOKEN 203
#define ACTION_SHEET_PRINT_COPY 306

#define LEFT_PADDING 10.0
#define RIGHT_PADDING 10.0
#define HORIZONTAL_GAP 10.0
#define VERTICAL_GAP 10.0

@interface TheInfoViewController (){
        MainPageAppDelegate *_appDelegate;
}
@property(nonatomic,retain)NSArray *dataArray;

@end

@implementation TheInfoViewController
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray=[NSArray arrayWithObjects:@"关于“草根足球管家”",@"软件分享",@"帮助",@"功能简介",nil];
               _appDelegate = (MainPageAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = [UIImage imageNamed:@"背景.jpg"];
    self.view.layer.contents = (id) image.CGImage;
    [self.theNaviBar setTintColor:[UIColor clearColor]];
    [self.theNaviBar setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"返回_1.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0, 0.0, 50.5, 30.0)];
    [button setTitle:@"  返回" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [button addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:button];
    UINavigationItem *Navitem=[[UINavigationItem alloc] initWithTitle:@"关于我们"];
    Navitem.leftBarButtonItem=left;
    [self.theNaviBar pushNavigationItem:Navitem animated:NO];
    [Navitem release];
    [left release];
    
    [self.theTableView setBackgroundColor:[UIColor clearColor]];
    self.theTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.theTableView setFrame:CGRectMake(10, 54, 300, 450)];
    
    
    UIView *guideView=[[UIView alloc] init];
    [guideView setFrame:CGRectMake(0.0, 0.0, 320, self.view.bounds.size.height)];
    if (iPhone5) {
     guideView.layer.contents=(id)[UIImage imageNamed:@"21136.png"].CGImage;
        [guideView setFrame:CGRectMake(0.0, 0.0, 320,548)];

    }else{
    guideView.layer.contents=(id)[UIImage imageNamed:@"2.png"].CGImage;
    }
    guideView.tag=30;
    guideView.hidden=YES;
    [self.view addSubview:guideView];
    [guideView release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_theTableView release];
    [dataArray release];
    [_theNaviBar release];
    [super dealloc];
}
//tableview datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell.backgroundView setFrame:CGRectMake(0, 0, 320, 66)];
    cell.backgroundColor=[UIColor clearColor];
     UIImage *image = [UIImage imageNamed:@"分享等_button1.png"];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:image] autorelease];

    //cell.contentView.layer.contents=(id)image.CGImage;
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.section];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view setBackgroundColor:[UIColor clearColor]];
    return [view autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
   // cell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            //关于我们{
                AboutUsViewController *aboutus=[[AboutUsViewController alloc] initWithTitle:@"关于我们"];
            [self presentModalViewController:aboutus animated:YES];
            [aboutus release];
            break;
    }
            case 1:
            //分享
            [self performSelector:@selector(simpleShareAllButtonClickHandler:) withObject:tableView];
            break;
        case 2:{
            //帮助
            HelpViewController *aboutus=[[HelpViewController alloc] init];
            [self presentModalViewController:aboutus animated:YES];
            [aboutus release];
            break;
        }
        case 3:{
            //评分
            UIView *view=(UIView *)[self.view viewWithTag:30];
            if (iPhone5) {
            view.layer.contents=(id)[UIImage imageNamed:@"21136.jpg"].CGImage;
            }else{
            view.layer.contents=(id)[UIImage imageNamed:@"2.jpg"].CGImage;
            }
            
            [view fallIn:2 delegate:self startSelector:nil stopSelector:@selector(showALert)];

        }
            break;
        default:
            break;
    }
}

-(void)showALert{
    
    GuideViewController *guideView=[[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
    guideView.DisDelegate=self;
    [self presentModalViewController:guideView animated:NO];
    [guideView release];
    UIView *view=(UIView *)[self.view viewWithTag:30];
    if (iPhone5) {
    view.layer.contents=(id)[UIImage imageNamed:@"51136.jpg"].CGImage;

    }else{
    view.layer.contents=(id)[UIImage imageNamed:@"5.jpg"].CGImage;
    }
    
}
-(void)disMissView{
    UIView *view=(UIView *)[self.view viewWithTag:30];
    [view fallOut:2 delegate:nil];
}
- (IBAction)ComeBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)simpleShareAllButtonClickHandler:(id)sender{
    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    //ShareWithImage *shareView=[[ShareWithImage alloc] init];
    [app.shareView setTheContent:@"我在用草根足球管家管理我的足球队"];
    [app.shareView getMainImage];
    [app.shareView simpleShareAllButtonClickHandler:self.view];


}


/*
- (void)simpleShareAllButtonClickHandler:(id)sender
{
    //定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeWeixiSession,ShareTypeWeixiTimeline, nil];
    
    
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareimage" ofType:@"jpg"];
    
    id<ISSContent> publishContent = [ShareSDK content:@"我在草根足球管家管理我的球队，你在用什么管理你的球队?"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"草根足球管家"
                                                  url:@"http://www.mobkid.com/"
                                          description:@"草根足球管家"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:_appDelegate.viewDelegate
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:_appDelegate.viewDelegate];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    NSString *erroMes=[NSString stringWithFormat:@"分享失败,%@",[error errorDescription]];
                                    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:erroMes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }
                            }];
}


*/
- (void)viewDidUnload {
    [self setTheNaviBar:nil];
    [super viewDidUnload];
}
@end
