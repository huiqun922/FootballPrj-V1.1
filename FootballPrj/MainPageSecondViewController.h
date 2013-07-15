//
//  MainPageSecondViewController.h
//  FootballPrj
//
//  Created by ytt on 12-12-21.
//  Copyright (c) 2012年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageSecondViewController : UIViewController
@property (retain, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (retain, nonatomic) IBOutlet UITableView *theOverTable;
@property (retain, nonatomic) IBOutlet UITableView *theNextTable;
@property (retain, nonatomic) IBOutlet UILabel *labelNext;
@property (retain, nonatomic) IBOutlet UILabel *labelLast;

@end
