//
//  MainPageFirstViewController.h
//  FootballPrj
//
//  Created by ytt on 12-12-21.
//  Copyright (c) 2012年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainPageFirstViewController : UIViewController<UIApplicationDelegate>{
    //BOOL First;
}

@property(nonatomic,assign)BOOL First;

@property (retain, nonatomic) IBOutlet UINavigationBar *theNavBar;
@property (retain,nonatomic)NSArray *arrayData;
@property (retain, nonatomic)UIImageView *theImageView;
@property (retain, nonatomic) IBOutlet UIImageView *theDuihui;
@property (retain, nonatomic) IBOutlet UIImageView *theTextImage;
@property (retain, nonatomic) IBOutlet UILabel *labeltime;
@property (retain, nonatomic) IBOutlet UILabel *labelheader;
@property (retain, nonatomic) IBOutlet UILabel *money;
@property (retain, nonatomic) IBOutlet UITextView *TeamJianjie;
@property (retain, nonatomic) IBOutlet UITableView *theTableView;
- (IBAction)HidenView:(id)sender;

@end
