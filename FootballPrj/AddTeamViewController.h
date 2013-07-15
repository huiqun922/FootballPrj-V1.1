//
//  AddTeamViewController.h
//  FootballPrj
//
//  Created by mokbid on 13-5-9.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import "SetDefaultPhotoView.h"
#import <QuartzCore/QuartzCore.h>
//#import "ThePickerView.h"

@interface AddTeamViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditDelegate,DefaultPhotoDelegate>

@property (retain, nonatomic) IBOutlet UITableView *theTableView;
@end
