//
//  FMDBServers.h
//  FootballPrj
//
//  Created by mokbid on 13-5-10.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"


@interface FMDBServers : NSObject{
    
}
@property( retain,nonatomic)FMDatabase * dbs;
-(BOOL)OpenDatabase;
-(void)setDatabase;
-(BOOL)InsertDataWithIndex:(NSInteger)index InsertData:(NSArray *)DataArray;
-(BOOL)UpdateDataWithIndex:(NSInteger)index UpdateData:(NSArray *)DataArray Condition:(int)ConditionArray;
-(NSArray *)getDateFromTable:(NSInteger)index Condition:(NSArray *)ConditionArray;
-(void)close;

@end
