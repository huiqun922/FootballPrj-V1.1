//
//  TheScoreInfoView.h
//  FootballPrj
//
//  Created by mokbid on 13-5-14.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TheScoreDelegate <NSObject>

-(void)TheDicInfo:(NSArray *)array Index:(NSInteger)index Score:(NSInteger)score TheIDArray:(NSArray *)arrayID;
-(void)UpdateJinQiu:(NSArray *)array Index:(NSInteger)index Score:(NSInteger)score;
-(void)DeleteJinQiu:(NSArray *)array Index:(NSInteger)index Score:(NSInteger)score;

@end

@interface TheScoreInfoView : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (retain, nonatomic) IBOutlet UIButton *DeleteButton;
@property (retain, nonatomic) IBOutlet UITableView *theTableView;
@property (assign,nonatomic)id<TheScoreDelegate>TheDelegate;
@property(nonatomic,retain)NSMutableArray *arrayTabel;
@property(nonatomic)BOOL Add;
- (IBAction)DeleteScore:(UIButton *)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Index:(NSInteger)index;
@end
