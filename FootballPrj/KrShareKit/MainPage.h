//
//  MainPage.h
//  FootballPrj
//
//  Created by mokbid on 13-7-1.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPage : UIWindow
{
    UILabel *_messageLabel;
}

- (void)showStatusMessage:(NSString *)message;
- (void)hide;
@end
