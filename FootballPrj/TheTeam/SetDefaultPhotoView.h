//
//  SetDefaultPhotoView.h
//  FootballPrj
//
//  Created by mokbid on 13-5-14.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DefaultPhotoDelegate <NSObject>

-(void)theSelectPhoto:(UIImage *)image;

@end

@interface SetDefaultPhotoView : UIViewController
@property(nonatomic,assign)id<DefaultPhotoDelegate>photoDelegate;
@property (retain, nonatomic) IBOutlet UIScrollView *theScroller;

- (IBAction)ReturnPhoto:(UIButton *)sender;

@end
