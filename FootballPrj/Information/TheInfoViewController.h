//
//  TheInfoViewController.h
//  FootballPrj
//
//  Created by mokbid on 13-5-8.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GuideViewController.h"


@interface TheInfoViewController : UIViewController<disDelegate>
@property (retain, nonatomic) IBOutlet UITableView *theTableView;

@property (retain, nonatomic) IBOutlet UINavigationBar *theNaviBar;
- (IBAction)ComeBack:(id)sender;
@end
