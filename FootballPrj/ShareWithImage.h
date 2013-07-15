//
//  ShareWithImage.h
//  FootballPrj
//
//  Created by mokbid on 13-5-20.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "KRShare.h"
#import "SysFunction.h"
#import "WXApi.h"


@interface ShareWithImage : NSObject<UIApplicationDelegate,KRShareDelegate,KRShareRequestDelegate,UIActionSheetDelegate>{
    KRShare *_krShare;
    enum WXScene _scene;
 

}
@property(nonatomic,copy)NSString *theContent;
- (void)simpleShareAllButtonClickHandler:(id)sender;
-(void)getImageFromView:(UIView *)orgView;
-(void)getMainImage;
@end
