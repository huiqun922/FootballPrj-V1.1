//
//  AddMemberView.h
//  FootballPrj
//
//  Created by mokbid on 13-5-10.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import "SetDefaultPhotoView.h"

@interface AddMemberView : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditDelegate,DefaultPhotoDelegate>

@property (retain, nonatomic) IBOutlet UITableView *theTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil theInfo:(NSDictionary *)Dic;
@end
