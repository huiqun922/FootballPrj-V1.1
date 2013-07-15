//
//  MainPageAppDelegate.m
//  FootballPrj
//
//  Created by ytt on 12-12-21.
//  Copyright (c) 2012年 ytt. All rights reserved.
#import "MainPageAppDelegate.h"
#import "MainPageFirstViewController.h"
#import "MainPageSecondViewController.h"
#import "GuideViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MainPageViewController.h"
#import "FMDBServers.h"
#import "JSONKit.h"
#import "FTAnimation.h"


@implementation MainPageAppDelegate
@synthesize dbs;
@synthesize shareView;
//@synthesize viewDelegate=_viewDelegate;
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_theMainview release];
    [shareView release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [WXApi registerApp:@"wxce486ad95d073222"];
    
    shareView=[[ShareWithImage alloc] init];
    
    FMDBServers *fmdbs=[[[FMDBServers alloc] init] autorelease];
    [fmdbs setDatabase];
    [fmdbs close];
    


    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    //self.theMainview=[[[MainPageViewController alloc] init] autorelease];
    
    if (iPhone5) {
        self.theMainview=[[MainPageViewController alloc] initWithNibName:@"MainPageViewController_i5" bundle:nil];
        
    }else{
        self.theMainview=[[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
    }
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"isFirstLogin.plist"];
    NSMutableDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //加载简介显示
    guideVC = [[GuideViewController alloc]initWithNibName:@"GuideViewController" bundle:nil];
    // 第一次登录
    if (tempDict == nil) {
        self.window.rootViewController=guideVC;
        
        //[self.window insertSubview:guideVC.view atIndex:0];
    }
    // 非第一次登录
    else {
        self.window.rootViewController=self.theMainview;
        //[self.window insertSubview:mainVC.view atIndex:0];
    }
    

    //self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSLog(@"applicationDidBecomeActive");

    

    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:50];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
    FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT * FROM Bisai where GameOver=?",@"NO"];
    while ([rs next]) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
        [dic setValue:[rs stringForColumn:@"Date"] forKey:@"Date"];
        [dic setValue:[rs stringForColumn:@"GameOver"] forKey:@"GameOver"];
        [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
        [array addObject:dic];
    }
    [rs close];
    }
    //NSLog(@"Bisai : %@",array);
    NSDate *Now=[NSDate date];
    
    for (int i=0; i<[array count]; i++) {
        NSString *stringDate=[[array objectAtIndex:i] objectForKey:@"Date"];
           int theID=[[[array objectAtIndex:i] objectForKey:@"ID"] intValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateStyle:kCFDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        if([stringDate length]<17){
           
            [dateFormatter release];
            continue;
        }
        NSDate *date = [dateFormatter dateFromString:[stringDate substringToIndex:17]];
        [dateFormatter release];
             //NSLog(@"Date  %@",[Now laterDate:date]);
        
        if( [[Now laterDate:date] isEqualToDate:Now]){
            //NSLog(@"Date");
           //更新比赛
        [fmdbs.dbs executeUpdate:@"UPDATE  Bisai set GameOver = ? where ID = ?",@"YES",[NSNumber numberWithInt:theID]];
            //更新球员出场次数
            NSString *buttontitle = [fmdbs.dbs stringForQuery:@"SELECT MemberID FROM CanSai WHERE BisaiID = ?",[NSString stringWithFormat:@"%d",theID]];
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[buttontitle objectFromJSONString]];
            NSMutableArray *CanSaiRenShu=[NSMutableArray arrayWithCapacity:50];
            for (int i=1; i<=32; i++) {
             
              NSString *String=  [[dic objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"ID"];
                int m=[String intValue];
                if (String!=NULL) {
                    [CanSaiRenShu addObject:String];
                    NSLog(@"... %@",String);
                    NSString *Score = [fmdbs.dbs stringForQuery:@"SELECT ChangCi FROM User WHERE ID = ?",[NSNumber numberWithInt:m]];
                    int theScore=[Score intValue]+1;
                    
                    [fmdbs.dbs executeUpdate:@"UPDATE User SET ChangCi = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theScore],[NSNumber numberWithInt:m]];
                }
                //        NSLog(@"%d   %@",i,[[self.dicMember objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"Name"]);
            }
            
        //插入进球详情
        [fmdbs InsertDataWithIndex:3 InsertData:[NSArray arrayWithObjects:[[array objectAtIndex:i] objectForKey:@"ID"] ,@" ", nil]];
        //插入球队财务
        [fmdbs InsertDataWithIndex:4 InsertData:[NSArray arrayWithObjects:[[array objectAtIndex:i]objectForKey:@"ID"] ,[[array objectAtIndex:i] objectForKey:@"Date"],@"0",[NSString stringWithFormat:@"%@",[CanSaiRenShu JSONString]],[[NSUserDefaults standardUserDefaults] objectForKey:@"TheTeamMoney"], nil]];
        
    }
    }

    [fmdbs close];
    [fmdbs release];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)changeToMainWindow:(UIView *)theView
{
   UIView *view=[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.window insertSubview:view belowSubview:guideVC.view];
    
    //[self.tabBarController.view setFrame:[[UIScreen mainScreen] bounds]];
    
    [UIView beginAnimations:@"flipAnim" context:NULL];// 動畫開始
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp
                           forView:self.window cache:YES];// 翻轉效果
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; // 動畫時間曲線
    [UIView setAnimationDuration:1.0f];// 動畫時間
    [UIView setAnimationDidStopSelector:@selector(AnimationStop:)];
    // 將兩個已加入的View切換
    [self.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView commitAnimations];// 動畫結束
    
//    [theView addSubview:self.theMainview.view];
//    [self.theMainview.view setHidden:YES];
    
    [self.theMainview.view popIn:1 delegate:nil];
    
      //self.theMainview.First=YES;
     self.window.rootViewController=self.theMainview;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}



/*
-(void) onSentTextMessage:(BOOL) bSent{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void) onSentMediaMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%u", bSent];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
*/


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
//微信分享
-(void) onReq:(BaseReq*)req
{
    //    if([req isKindOfClass:[GetMessageFromWXReq class]])
    //    {
    //        [self onRequestAppMessage];
    //    }
    //    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    //    {
    //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
    //        [self onShowMediaMessage:temp.message];
    //    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSLog(@"error : %@",resp.errStr);
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送消息结果:%d", resp.errCode];
        if (resp.errCode==0) {
            strMsg=@"发送成功";
        }else if(resp.errCode==-2){
            strMsg=[NSString stringWithFormat:@"发送取消"];
        }else{
            strMsg=[NSString stringWithFormat:@"发送失败"];

        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
@end
