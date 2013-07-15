//
//  TheOverGame.h
//  FootballPrj
//
//  Created by mokbid on 13-5-14.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheScoreInfoView.h"

@interface TheOverGame : UIViewController<TheScoreDelegate>
@property(nonatomic,copy)NSString *BiSaiID;
@property(assign)NSInteger ScoreW;
@property(assign)NSInteger ScoreD;

@property (retain, nonatomic) IBOutlet UILabel *labelWo;
@property (retain, nonatomic) IBOutlet UILabel *labelDui;
@property (retain, nonatomic) IBOutlet UIButton *buttonDui;
@property (retain, nonatomic) IBOutlet UIButton *buttonWo;
@property (retain, nonatomic) IBOutlet UITableView *WFtabelView;
@property (retain, nonatomic) IBOutlet UITableView *DFtableView;
- (IBAction)AddDuiFang:(id)sender;

- (IBAction)AddWoFang:(id)sender;
@end
