//
//  TheNextGame.h
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNextGame : UIViewController
@property (retain, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (retain, nonatomic) IBOutlet UIButton *theDeleteButton;
@property (retain, nonatomic) IBOutlet UILabel *theLabel;
- (IBAction)DeleteGame:(UIButton *)sender;

- (IBAction)SelectMember:(UIButton *)sender;
-(void)SetID:(NSString *)stringID;

@end
