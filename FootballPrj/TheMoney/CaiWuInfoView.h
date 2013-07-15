//
//  CaiWuInfoView.h
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaiWuInfoView : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) UITableView *theTableView;
-(void)setDefaultTableView:(NSDictionary *)Dic Personal:(BOOL)personal;
@end
