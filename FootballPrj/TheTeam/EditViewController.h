//
//  EditViewController.h
//  FootballPrj
//
//  Created by mokbid on 13-5-9.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegexKitLite.h"

@protocol EditDelegate <NSObject>

-(void)EditData:(NSString *)theString Index:(NSInteger)index;

@end

@interface EditViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *theLabel;
@property (retain, nonatomic) IBOutlet UITextView *thetTextView;

@property (retain, nonatomic) IBOutlet UIImageView *theTextImage;
@property (retain, nonatomic) IBOutlet UITextField *theTextField;
@property(nonatomic,assign)id<EditDelegate>editdelegate;

-(id)initWithTitleIndex:(NSInteger)title Conten:(NSString *)ContenString Length:(NSInteger)length KeyType:(NSInteger)keyboardType;

@end
