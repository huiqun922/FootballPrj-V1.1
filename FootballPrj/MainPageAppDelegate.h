//
//  MainPageAppDelegate.h
//  FootballPrj
//
//  Created by ytt on 12-12-21.
//  Copyright (c) 2012年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "ShareWithImage.h"
//#import <QQApi/QQApi.h>
//#import "WeChatViewController.h"
//#import "AGViewDelegate.h"

@class GuideViewController;
@class FMDatabase;
@class MainPageViewController;



@interface MainPageAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,WXApiDelegate>{
    GuideViewController * guideVC;
    FMDatabase * dbs;
    //enum WXScene _scene;
    //AGViewDelegate *_viewDelegate;
    
}
@property(nonatomic,strong)ShareWithImage *shareView;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (retain,nonatomic)MainPageViewController *theMainview;
@property( retain,nonatomic)FMDatabase * dbs;
//@property (nonatomic,readonly) AGViewDelegate *viewDelegate;

-(void)changeToMainWindow:(UIView *)theView;
@end   