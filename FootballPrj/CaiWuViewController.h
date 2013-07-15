//
//  CaiWuViewController.h
//  FootballPrj
//
//  Created by mokbid on 13-5-8.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CaiWuViewController : UIViewController
@property (retain, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (retain, nonatomic) IBOutlet UIButton *TeamButton;
- (IBAction)SelectPersonal:(UIButton *)sender;

- (IBAction)SelectTeam:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *PersonalButton;
@property (retain, nonatomic) IBOutlet UITableView *theTableView;
- (IBAction)SelectCaiwu:(id)sender;
@end
