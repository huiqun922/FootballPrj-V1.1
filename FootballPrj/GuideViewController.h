//
//  GuideViewController.h
//  FindMe
//
//  Created by  on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageViewController.h"
#import "FTAnimation.h"

@protocol disDelegate <NSObject>

-(void)disMissView;

@end

@interface GuideViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView   *guideScrollView;
    IBOutlet UIPageControl  *guidePageControl;
    NSMutableArray *contentAr;
}
@property(assign)NSInteger jianjie;
@property(nonatomic,assign)id<disDelegate>DisDelegate;
-(void)jumpToFirstView;

@end
