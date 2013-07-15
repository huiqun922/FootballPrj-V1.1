//
//  MainPage.m
//  FootballPrj
//
//  Created by mokbid on 13-7-1.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "MainPage.h"

@implementation MainPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor blackColor];
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        _messageLabel=[[UILabel alloc] initWithFrame:self.frame];
        [_messageLabel setBackgroundColor:[UIColor clearColor]];
        [_messageLabel setTextColor:[UIColor whiteColor]];
        [_messageLabel setTextAlignment:UITextAlignmentCenter];
        [_messageLabel setFont:[UIFont systemFontOfSize:13.0]];
        
        [self addSubview:_messageLabel];

    }
    return self;
}
- (void)showStatusMessage:(NSString *)message
{
    self.hidden = NO;
    self.alpha = 1.0f;
    _messageLabel.text = @"正在发送";
    
    CGSize totalSize = self.frame.size;
    self.frame = (CGRect){ self.frame.origin, 0, totalSize.height };
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = (CGRect){ self.frame.origin, totalSize };
    } completion:^(BOOL finished){
        _messageLabel.text = message;
    }];
}

- (void)hide
{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        _messageLabel.text = @"";
        self.hidden = YES;
    }];;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
