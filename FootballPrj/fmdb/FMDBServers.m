//
//  FMDBServers.m
//  FootballPrj
//
//  Created by mokbid on 13-5-10.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

//index
//球员信息 0
//比赛信息 1
//参赛人员 2
//进球详情 3
//球队财务 4
//个人财务 5


#import "FMDBServers.h"

@implementation FMDBServers
@synthesize dbs;

-(BOOL)OpenDatabase{
    //创建数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
   //NSString *documentDirectory = @"/Users/mobkidmobkid/Desktop/";

    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyFootBall.sql"];
    self.dbs= [FMDatabase databaseWithPath:dbPath];
    return [self.dbs open];
    
}
-(void)setDatabase{

    if (![self OpenDatabase]) {
        NSLog(@"Could not open db.");
    }else {
        //在数据库打开的情况下，查询表  如果存在 就不重新建立
        //球队财务
        NSString *sql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and table='%@'", @"TeamCaiwu"];
        int tableCount = [self.dbs intForQuery:sql] ;
        if (tableCount <= 0) {
            [self.dbs executeUpdate:@"CREATE TABLE TeamCaiwu (ID INTEGER PRIMARY KEY AUTOINCREMENT, BiSaiID text,date text,renJunXiaoFei text , CanJiaRenShu  text , yuE text )"];
        }
        //队员
        NSString * sql1 =[NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and table='%@'",@"User"];
        int tableCount1 = [self.dbs intForQuery:sql1] ;
        if (tableCount1 <= 0) {
            [self.dbs executeUpdate:@"CREATE TABLE User (ID INTEGER PRIMARY KEY AUTOINCREMENT, name text,phoneNum text , QQ text,Number text,weiZhi  text,Jianjie text,JinQiu text,ZhuGong text,ChangCi text)"];
        }
        //比赛
        NSString * sql2 =[NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and table='%@'",@"Bisai"];
        int tableCount2 = [self.dbs intForQuery:sql2] ;
        if (tableCount2 <= 0) {
            [self.dbs executeUpdate:@"CREATE TABLE Bisai (ID INTEGER PRIMARY KEY AUTOINCREMENT, Date text,Address text , Enemy  text , Zhenxing text,MyScore text,YouScore text,GameOver text)"];
        }
        //参赛人员
        NSString * sql3 =[NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and table='%@'",@"CanSai"];
        int tableCount3 = [self.dbs intForQuery:sql3] ;
        if (tableCount3 <= 0) {
            [self.dbs executeUpdate:@"CREATE TABLE CanSai (ID INTEGER PRIMARY KEY AUTOINCREMENT,BisaiID text,MemberID text)"];
        }
        //进球详情
        NSString * sql4 =[NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and table='%@'",@"JinQiu"];
        int tableCount4 = [self.dbs intForQuery:sql4] ;
        if (tableCount4 <= 0) {
            [self.dbs executeUpdate:@"CREATE TABLE JinQiu (ID INTEGER PRIMARY KEY AUTOINCREMENT, Date text,MemberID text,BisaiID text)"];
        }
        //个人财务
        NSString * sql5 =[NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and table='%@'",@"CaiWu"];
        int tableCount5 = [self.dbs intForQuery:sql5] ;
        if (tableCount5 <= 0) {
            [self.dbs executeUpdate:@"CREATE TABLE CaiWu (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name text,Money text , HandedMoney text ,Date text,MemberID text)"];
        }
        
    }
    [self.dbs close];
}
-(BOOL)InsertDataWithIndex:(NSInteger)index InsertData:(NSArray *)DataArray{
    BOOL result=YES;

    if (![self OpenDatabase]) {
        return NO;
    }
   
    switch (index) {
        case 0:
        {
            //队员信息
           result=[self.dbs executeUpdate:@"INSERT INTO User (name,phoneNum, QQ ,Jianjie,weiZhi,Number ,JinQiu,ZhuGong,ChangCi) VALUES (?,?,?,?,?,?,?,?,?)",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[DataArray objectAtIndex:3],[DataArray objectAtIndex:4],[DataArray objectAtIndex:5],[DataArray objectAtIndex:6],[DataArray objectAtIndex:7],[DataArray objectAtIndex:8]];
        }
            break;
        case 1:{
            NSString *stringDate=[DataArray objectAtIndex:0];
            NSString *gameOver=@"NO";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            if([stringDate length]<17){
                [dateFormatter release];
                return NO;
            }
            NSDate *date = [dateFormatter dateFromString:[stringDate substringToIndex:17]];
            [dateFormatter release];
            NSDate *Now=[NSDate date];
            if( [[Now laterDate:date] isEqualToDate:Now]){
                gameOver=@"YES";
            }
            //比赛信息
         result=[self.dbs executeUpdate:@"INSERT INTO Bisai (Date,Address ,Enemy,Zhenxing,MyScore ,YouScore,GameOver) VALUES (?,?,?,?,?,?,?)",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[DataArray objectAtIndex:3],@"0",@"0",gameOver];
            
            NSString *bisaiID=[NSString string];
            if (result) {
                
                FMResultSet *rs=[self.dbs executeQuery:@"SELECT ID FROM Bisai order by ID desc"];
                if ([rs next]) {
                   bisaiID = [rs stringForColumn:@"ID"];
                    
                }
                [rs close];
                if([gameOver isEqualToString:@"YES"]){
                //插入进球详情
                [self InsertDataWithIndex:3 InsertData:[NSArray arrayWithObjects:bisaiID ,@" ", nil]];
               
                //插入球队财务
               [self InsertDataWithIndex:4 InsertData:[NSArray arrayWithObjects:bisaiID ,[DataArray objectAtIndex:0],@"0",@" ",[[NSUserDefaults standardUserDefaults] objectForKey:@"TheTeamMoney"], nil]];
                }
                
                
            }
            
                   
            
        }break;
            case 2:
        {
            //参赛人员
           
                result=[self.dbs executeUpdate:@"INSERT INTO CanSai (BisaiID,MemberID) VALUES (?,?)",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1]];
        }break;
        case 3:{
            //进球详情

            //NSLog(@"DateArray : %@",DataArray);
            result=[self.dbs executeUpdate:@"INSERT INTO JinQiu (BisaiID,MemberID) VALUES (?,?)",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1]];
                
        }break;
        case 4:{
            //球队财务
    
                       
                result=[self.dbs executeUpdate:@"INSERT INTO TeamCaiwu (BiSaiID,date,renJunXiaoFei,CanJiaRenShu,yuE) VALUES (?,?,?,?,?)",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[DataArray objectAtIndex:3],[DataArray objectAtIndex:4]];
            
        }break;
        case 5:{
            //个人财务
            
            result=[self.dbs executeUpdate:@"INSERT INTO CaiWu (Name,Money ,HandedMoney,Date,MemberID) VALUES (?,?,?,?,?)",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[DataArray objectAtIndex:3],[DataArray objectAtIndex:4]];

        }
            break;
        default:
            break;
    }
    return result;
}
-(BOOL)UpdateDataWithIndex:(NSInteger)index UpdateData:(NSArray *)DataArray Condition:(int)ConditionArray{
    if (![self OpenDatabase]) {
        return NO;
    }
    BOOL result = NO;
    switch (index) {
        case 0:
        {
            //队员信息
            result=[self.dbs executeUpdate:@"UPDATE  User set name = ?, phoneNum = ?,  QQ = ?, Jianjie=?, weiZhi =? , Number =? where ID = ? ",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[DataArray objectAtIndex:3],[DataArray objectAtIndex:4],[DataArray objectAtIndex:5],[NSNumber numberWithInt:ConditionArray] ];
            
            
//                        result=[self.dbs executeUpdate:@"UPDATE  User set name = ?, phoneNum = ?,  QQ = ?, Jianjie=?, weiZhi =? , Number =? where ID = ? ",@"Name",@"phoneNum",@"QQ",@" ",@"weiZhi",@"Number",[NSNumber numberWithInt:9] ];
            if ([self.dbs hadError]) {
                NSLog(@"Err %d: %@", [dbs lastErrorCode], [dbs lastErrorMessage]);
                //success = NO;
            }
            
        }
            break;
        case 1:
        {
            //比赛信息
            result=[self.dbs executeUpdate:@"UPDATE  Bisai set Date = ?, Address = ?,  Enemy = ?, Zhenxing = ?, MyScore =? , YouScore =? where ID = ?",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[DataArray objectAtIndex:3],[DataArray objectAtIndex:4],[DataArray objectAtIndex:5],ConditionArray];
            
        }break;
        case 3:{
            //进球详情

            result=[self.dbs executeUpdate:@"UPDATE  JinQiu set MemberID = ? where BisaiID = ?",[DataArray objectAtIndex:0],[NSString stringWithFormat:@"%d",ConditionArray]];
        }break;
        case 4:{
            //球队财务
            result=[self.dbs executeUpdate:@"UPDATE TeamCaiWu set renJunXiaoFei=?,CanJiaRenShu=?,yuE=? where BiSaiID=?",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[NSString stringWithFormat:@"%d",ConditionArray]];
            
            if ([self.dbs hadError]) {
                NSLog(@"Err %d: %@", [dbs lastErrorCode], [dbs lastErrorMessage]);
                //success = NO;
            }
            
        }break;
            case 5:
        {
            result=[self.dbs executeUpdate:@"UPDATE CaiWu set Money = ?,HandedMoney = ?,Date = ? where ID= ?",[DataArray objectAtIndex:0],[DataArray objectAtIndex:1],[DataArray objectAtIndex:2],[NSNumber numberWithInt:ConditionArray]];
            
        }break;
            
        default:
        {

        }
            break;
    }
    return result;
}
-(BOOL)DeleteData:(NSInteger)index TheKey:(NSInteger)key{
    if (![self OpenDatabase]) {
        return NO;
    }
    BOOL result = YES;
    switch (index) {
        case 0:
        {
            //队员信息
            result=[self.dbs executeUpdate:@"DELETE from User where ID = ?",key];
        }
            break;
            case 1:
        {
            //比赛信息
            result=[self.dbs executeUpdate:@"DELETE from Bisai where ID = ?",key];
        }
            
        default:
            break;
    }
    return result;
}
-(NSArray *)getDateFromTable:(NSInteger)index Condition:(NSArray *)ConditionArray{
    if (![self OpenDatabase]) {
        return NO;
    }
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:50];
    switch (index) {
        case 0:
        {
            FMResultSet *rs = [self.dbs executeQuery:@"SELECT * FROM User order by ID desc"];
            while ([rs next]) {
                NSLog(@"%@",[rs stringForColumn:@"ID"]);
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
                [dic setValue:[rs stringForColumn:@"name"] forKey:@"Name"];
                [dic setValue:[rs stringForColumn:@"phoneNum"] forKey:@"phoneNum"];
                [dic setValue:[rs stringForColumn:@"QQ"] forKey:@"QQ"];
                [dic setValue:[rs stringForColumn:@"Number"] forKey:@"Number"];
                [dic setValue:[rs stringForColumn:@"weiZhi"] forKey:@"weiZhi"];
                [dic setValue:[rs stringForColumn:@"Jianjie"] forKey:@"Jianjie"];
                [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
                [dic setValue:[rs stringForColumn:@"JinQiu"] forKey:@"JinQiu"];
                [dic setValue:[rs stringForColumn:@"ZhuGong"] forKey:@"ZhuGong"];
                [dic setValue:[rs stringForColumn:@"ChangCi"] forKey:@"ChangCi"];
                [array addObject:dic];
            }
            
            [rs close];
        }
            break;
            case 1:
        {
            FMResultSet *rs = [self.dbs executeQuery:@"SELECT * FROM Bisai  order by ID desc"];
            while ([rs next]) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
                [dic setValue:[rs stringForColumn:@"Date"] forKey:@"Date"];
                [dic setValue:[rs stringForColumn:@"Address"] forKey:@"Address"];
                [dic setValue:[rs stringForColumn:@"Enemy"] forKey:@"Enemy"];
                [dic setValue:[rs stringForColumn:@"Zhenxing"] forKey:@"Zhenxing"];
                [dic setValue:[rs stringForColumn:@"MyScore"] forKey:@"MyScore"];
                [dic setValue:[rs stringForColumn:@"YouScore"] forKey:@"YouScore"];
                [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
                [array addObject:dic];
            }
            
            [rs close];
        }
            break;
        case 2:{
                        
            FMResultSet *rs = [self.dbs executeQuery:@"SELECT * FROM CanSai order by ID desc"];
            while ([rs next]) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
                [dic setValue:[rs stringForColumn:@"BisaiID"] forKey:@"Date"];
                [dic setValue:[rs stringForColumn:@"MemberID"] forKey:@"Address"];
                [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
                [array addObject:dic];
            }
            
            [rs close];
        }break;
            
        case 11:{
            FMResultSet *rs = [self.dbs executeQuery:@"SELECT * FROM Bisai where GameOver = ? order by ID desc",@"NO"];
            while ([rs next]) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
                [dic setValue:[rs stringForColumn:@"Date"] forKey:@"Date"];
                [dic setValue:[rs stringForColumn:@"Address"] forKey:@"Address"];
                [dic setValue:[rs stringForColumn:@"Enemy"] forKey:@"Enemy"];
                [dic setValue:[rs stringForColumn:@"Zhenxing"] forKey:@"Zhenxing"];
                [dic setValue:[rs stringForColumn:@"MyScore"] forKey:@"MyScore"];
                [dic setValue:[rs stringForColumn:@"YouScore"] forKey:@"YouScore"];
                [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
                [array addObject:dic];
            }
            
            [rs close];
        }
            break;
        case 12:{
            FMResultSet *rs = [self.dbs executeQuery:@"SELECT * FROM Bisai where GameOver = ? order by ID desc",@"YES"];
            while ([rs next]) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
                [dic setValue:[rs stringForColumn:@"Date"] forKey:@"Date"];
                [dic setValue:[rs stringForColumn:@"Address"] forKey:@"Address"];
                [dic setValue:[rs stringForColumn:@"Enemy"] forKey:@"Enemy"];
                [dic setValue:[rs stringForColumn:@"Zhenxing"] forKey:@"Zhenxing"];
                [dic setValue:[rs stringForColumn:@"MyScore"] forKey:@"MyScore"];
                [dic setValue:[rs stringForColumn:@"YouScore"] forKey:@"YouScore"];
                [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
                [array addObject:dic];
            }
            
            [rs close];
        }
            break;
        default:
            break;
    }
    

    return array;

}
-(void)close{
    [self.dbs close];
}
-(void)dealloc{
    self.dbs=nil;
    [super dealloc];
}
@end
