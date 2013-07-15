//
//  TheMemberInfoView.h
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheMemberInfoView : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *labelQQ;
@property (retain, nonatomic) IBOutlet UILabel *labelPhone;
@property (retain, nonatomic) IBOutlet UIImageView *theTextImage;

@property (retain, nonatomic) IBOutlet UIImageView *thedataimage;
@property (retain, nonatomic) IBOutlet UITextView *theTextView;
@property (retain, nonatomic) IBOutlet UILabel *labelW;
@property (retain, nonatomic)UIImageView *theImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil TheInfo:(NSDictionary *)dic;
@property (retain, nonatomic) IBOutlet UILabel *labelJQ;
@property (retain, nonatomic) IBOutlet UILabel *labelZG;

@property (retain, nonatomic) IBOutlet UIImageView *fengexian;
@property (retain, nonatomic) IBOutlet UILabel *LabelCC;
@property (retain, nonatomic) IBOutlet UILabel *labelJE;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *label11;
@property (retain, nonatomic) IBOutlet UILabel *label12;
@property (retain, nonatomic) IBOutlet UILabel *label13;
@property (retain, nonatomic) IBOutlet UILabel *label14;
- (IBAction)DeleteMember:(UIButton *)sender;

@end
