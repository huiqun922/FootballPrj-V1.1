//
//  NSDictionary+theCompare.h
//  FootballPrj
//
//  Created by mokbid on 13-5-15.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (theCompare)
- (NSComparisonResult)compareShengXu: (NSDictionary *)otherDictionary;

- (NSComparisonResult)compareJiangXu: (NSDictionary *)otherDictionary;
@end
