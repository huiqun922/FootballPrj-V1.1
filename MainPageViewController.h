//
//  MainPageViewController.h
//  FootballPrj
//
//  Created by mokbid on 13-5-8.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController<UITabBarControllerDelegate>{
    
}
@property (assign)NSInteger fuckday;
@property (retain, nonatomic) IBOutlet UINavigationBar *theNavgation;

@property (retain, nonatomic)UIBarButtonItem *theInfoButton;
@property(nonatomic,retain)UITabBarController *theTabBarVC;
@property(nonatomic,assign)BOOL First;

- (IBAction)SelectTheInfo:(UIBarButtonItem *)sender;
- (IBAction)MyTeam:(id)sender;
- (IBAction)FootGame:(id)sender;
- (IBAction)TeamMember:(id)sender;
- (IBAction)Finance:(id)sender;


@end
