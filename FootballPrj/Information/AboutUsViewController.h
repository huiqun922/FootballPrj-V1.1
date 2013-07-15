//
//  AboutUsViewController.h
//  FootballPrj
//
//  Created by mokbid on 13-5-9.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UINavigationBar *theNavBar;
- (id)initWithTitle:(NSString *)title;
- (IBAction)ComeBack:(id)sender;
- (IBAction)OpenURL:(UIButton *)sender;


@end
