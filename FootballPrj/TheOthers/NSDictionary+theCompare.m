//
//  NSDictionary+theCompare.m
//  FootballPrj
//
//  Created by mokbid on 13-5-15.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "NSDictionary+theCompare.h"

@implementation NSDictionary (theCompare)
- (NSComparisonResult)compareShengXu: (NSDictionary *)otherDictionary
{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [NSNumber numberWithInteger:[[tempDictionary objectForKey:@"ChangCi"] intValue] ];
    NSNumber *number2 = [NSNumber numberWithInteger:[[tempDictionary objectForKey:@"ChangCi"] intValue] ];
    
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
}
- (NSComparisonResult)compareJiangXu: (NSDictionary *)otherDictionary
{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    
    NSComparisonResult result = [number1 compare:number2];
    
   // return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
}
@end
