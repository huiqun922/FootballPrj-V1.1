//
//  MainPageThreeViewController.h
//  FootballPrj
//
//  Created by ytt on 12-12-28.
//  Copyright (c) 2012年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface MainPageThreeViewController : UIViewController<MFMessageComposeViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UINavigationItem *theNavBar;
- (IBAction)SelectWeiZhi:(id)sender;
- (IBAction)SelectChangCi:(id)sender;
- (IBAction)SelectJinQiu:(id)sender;
- (IBAction)SelectZhuGong:(id)sender;

@property (retain, nonatomic) IBOutlet UITableView *theTableView;
@end
