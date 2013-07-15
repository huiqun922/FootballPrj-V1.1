//
//  MainPageSecondViewController.m
//  FootballPrj
//
//  Created by ytt on 12-12-21.
//  Copyright (c) 2012年 ytt. All rights reserved.
//

#import "MainPageSecondViewController.h"
#import "AddGameView.h"
#import "TheNextGame.h"
#import "TheOverGame.h"
#import "FMDBServers.h"
#import "JSONKit.h"


@interface MainPageSecondViewController ()
@property(nonatomic,retain)NSMutableArray *arrayTable;
@property(nonatomic,retain)NSMutableArray *arrayOver;

@end

@implementation MainPageSecondViewController
@synthesize arrayTable;
@synthesize arrayOver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = (@"Second", @"Second");
        self.title=@"比赛管理";
        self.tabBarItem.image = [UIImage imageNamed:@"比赛管理.png"];
        
        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"返回_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"  返回" forState:UIControlStateNormal];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonleft addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.leftBarButtonItem=left;
        
        UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonright setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonright setTitle:@"添加" forState:UIControlStateNormal];
        [buttonright setFrame:CGRectMake(0, 0, 50.5, 30.5)];
        [buttonright.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonright addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonright];
        self.navigationItem.rightBarButtonItem=right;
        
        
        [left release];
        [right release];

        
    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    AddGameView *addgame=[[AddGameView alloc] init];
    [addgame setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addgame animated:YES];
    [addgame release];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    for (int i=0; i<[self.arrayTable count]; i++) {
        [self TheGameOver:[self.arrayTable objectAtIndex:i]];
    }
    
    FMDBServers *fmdbs=[[FMDBServers alloc]init];
    self.arrayTable=[NSMutableArray arrayWithArray:[fmdbs getDateFromTable:11 Condition:nil]];
   self.arrayTable =[NSMutableArray arrayWithArray:[self ArrayPaiXu:self.arrayTable TheBOOL:YES]];
    self.arrayOver=[NSMutableArray arrayWithArray:[fmdbs getDateFromTable:12 Condition:nil]];
    self.arrayOver =[NSMutableArray arrayWithArray:[self ArrayPaiXu:self.arrayOver TheBOOL:NO]];

    [self.theNextTable reloadData];
    [self.theOverTable reloadData];
    [fmdbs close];
    [fmdbs release];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    //[self.theNextTable ]
    UIView *view=[[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    view.layer.contents=(id)[UIImage imageNamed:@"黑色半透明蒙版.png"].CGImage;
    [self.theNextTable setBackgroundView:view];
    UIView *view1=[[UIView alloc] init];
    [view1 setBackgroundColor:[UIColor clearColor]];
    view1.layer.contents=(id)[UIImage imageNamed:@"黑色半透明蒙版.png"].CGImage;
    [self.theNextTable setBackgroundColor:[UIColor clearColor]];
    [self.theOverTable setBackgroundColor:[UIColor clearColor]];
    [self.theOverTable setBackgroundView:view1];
    [view release];
    [view1 release];
    [self.labelLast setTextColor:[UIColor whiteColor]];
    [self.labelNext setTextColor:[UIColor whiteColor]];
    if (iPhone5) {
    [self.labelLast setFrame:CGRectMake(9.0, 225.0, 78.0, 21.0)];
    [self.theOverTable setFrame:CGRectMake(0.0, 246.0, 320.0, 162.0)];
    [self.theNextTable setFrame:CGRectMake(0.0, 27.0, 320, 152)];


    }else{
    [self.labelLast setFrame:CGRectMake(9.0, 168.0, 78.0, 21.0)];
    [self.theOverTable setFrame:CGRectMake(0.0, 190.0, 320.0, 212.0)];

    }
    //[self.theOverTable setFrame:CGRectMake(0.0, 192.0, 320.0, 212.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_theNavBar release];
    [arrayTable release];
    [_theOverTable release];
    [_theNextTable release];
    [_labelNext release];
    [_labelLast release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheNavBar:nil];
    [self setTheOverTable:nil];
    [self setTheNextTable:nil];
    [self setLabelNext:nil];
    [self setLabelLast:nil];
    [super viewDidUnload];
}

//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==10) {
    return [self.arrayTable count];
    }else{
        return [self.arrayOver count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idString=@"idString";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 160.0f, 36.0f)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=UITextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label release];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (tableView.tag==10) {
        cell.textLabel.text=[[self.arrayTable objectAtIndex:indexPath.row] objectForKey:@"Date"];
    }else{
         cell.textLabel.text=[[self.arrayOver objectAtIndex:indexPath.row] objectForKey:@"Date"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    return cell;
}
//tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    return 36.0f;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 10:
        {  if(![self TheGameOver:[self.arrayTable objectAtIndex:indexPath.row]]){
            TheNextGame *nextGame=[[TheNextGame alloc] initWithNibName:@"TheNextGame" bundle:nil];
            [nextGame SetID:[[self.arrayTable objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            [nextGame setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:nextGame animated:YES];
            [nextGame release];
            break;
        }else{
            [self.arrayOver insertObject:[self.arrayTable objectAtIndex:indexPath.row] atIndex:0];
            NSString *string=@"TheOverGame";
            if (iPhone5) {
                string=@"TheOverGame_i5";
            }
        
            TheOverGame *overGame=[[TheOverGame alloc] initWithNibName:string bundle:nil];
            [overGame setBiSaiID:[[self.arrayOver objectAtIndex:0] objectForKey:@"ID"]];
            overGame.ScoreW=[[[self.arrayOver objectAtIndex:0] objectForKey:@"MyScore"] intValue];
            overGame.ScoreD=[[[self.arrayOver objectAtIndex:0] objectForKey:@"YouScore"] intValue];
            
            [overGame setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:overGame animated:YES];
            [overGame release];
            
        }
        }
        break;
            
        default:{
            NSString *string=@"TheOverGame";
            if (iPhone5) {
                string=@"TheOverGame_i5";
            }
            
            TheOverGame *overGame=[[TheOverGame alloc] initWithNibName:string bundle:nil];
            [overGame setBiSaiID:[[self.arrayOver objectAtIndex:indexPath.row] objectForKey:@"ID"]];
            overGame.ScoreW=[[[self.arrayOver objectAtIndex:indexPath.row] objectForKey:@"MyScore"] intValue];
            overGame.ScoreD=[[[self.arrayOver objectAtIndex:indexPath.row] objectForKey:@"YouScore"] intValue];
            
            [overGame setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:overGame animated:YES];
            [overGame release];
        }
            break;
    }
}

-(NSArray *)ArrayPaiXu:(NSArray *)array TheBOOL:(BOOL)near{
    
    NSComparisonResult *resultDesc;
    NSComparisonResult *resultAsc;
    if (near) {
        resultDesc=NSOrderedDescending; //降序排列
        resultAsc=NSOrderedAscending;
    }
    else{
        resultDesc=NSOrderedAscending;
        resultAsc=NSOrderedDescending;
        
    }
    
    return  [array sortedArrayUsingComparator:^(id obj1,id obj2)
             {
                 NSDictionary *dic1 = (NSDictionary *)obj1;
                 NSDictionary *dic2 = (NSDictionary *)obj2;
                 NSString *num1 = [dic1 objectForKey:@"Date"];
                 NSString *num2 = [dic2 objectForKey:@"Date"];
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                 if([num1 length]<17){
                     //return nil;
                     [dateFormatter release];
                     return (NSComparisonResult)NSOrderedSame;
                     
                 }
                 NSDate *date1 = [dateFormatter dateFromString:[num1 substringToIndex:17]];
                 NSDate *date2 = [dateFormatter dateFromString:[num2 substringToIndex:17]];

                 [dateFormatter release];
               
                 if([[date1 laterDate:date2] isEqualToDate:date1]){
    
                     return (NSComparisonResult)resultDesc;
                 }
                 else
                 {
                     return (NSComparisonResult)resultAsc;
                 }
                 return (NSComparisonResult)NSOrderedSame;
             }];
}
//判断比赛是否进行完成,返回YES 比赛时间已过
-(BOOL)TheGameOver:(NSDictionary *)DicInfoGame{
    
   // NSLog(@" DIC :%@",DicInfoGame);
    //[dic retain];
    
    NSString *stringDate=[DicInfoGame objectForKey:@"Date"];
    int theID=[[DicInfoGame objectForKey:@"ID"] intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if([stringDate length]<17){
        //continue;
        [dateFormatter release];
        return YES;
    }
    NSDate *date = [dateFormatter dateFromString:[stringDate substringToIndex:17]];
    [dateFormatter release];
   // NSLog(@"Date  %@",[Now laterDate:date]);
    NSDate *Now=[NSDate date];
    if( [[Now laterDate:date] isEqualToDate:Now]){
        FMDBServers *fmdbs=[[FMDBServers alloc] init];
        if ([fmdbs OpenDatabase]) {
            
        //更新比赛
        [fmdbs.dbs executeUpdate:@"UPDATE  Bisai set GameOver = ? where ID = ?",@"YES",[NSNumber numberWithInt:theID]];
        //更新球员出场次数
        NSString *buttontitle = [fmdbs.dbs stringForQuery:@"SELECT MemberID FROM CanSai WHERE BisaiID = ?",[NSString stringWithFormat:@"%d",theID]];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[buttontitle objectFromJSONString]];
            NSMutableArray *CanSaiRenShu=[NSMutableArray arrayWithCapacity:50];
        for (int i=1; i<=32; i++) {
            NSString *String=  [[dic objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"ID"];
            int m=[String intValue];
            if (String!=NULL) {
                  [CanSaiRenShu addObject:String];
                NSLog(@"... %@",String);
                NSString *Score = [fmdbs.dbs stringForQuery:@"SELECT ChangCi FROM User WHERE ID = ?",[NSNumber numberWithInt:m]];
                int theScore=[Score intValue]+1;
                [fmdbs.dbs executeUpdate:@"UPDATE User SET ChangCi = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theScore],[NSNumber numberWithInt:m]];
            }
            //        NSLog(@"%d   %@",i,[[self.dicMember objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"Name"]);
        }
        
            //NSArray *arrayTest=[[NSArray alloc ]initWithObjects:@" ",@" ", nil];
        NSLog(@"arrayTest %@",[DicInfoGame objectForKey:@"ID"]);
        //插入进球详情
        [fmdbs InsertDataWithIndex:3 InsertData:[NSArray arrayWithObjects:[DicInfoGame objectForKey:@"ID"] ,@" ", nil]];
            
            
        //插入球队财务
        [fmdbs InsertDataWithIndex:4 InsertData:[NSArray arrayWithObjects:[DicInfoGame objectForKey:@"ID"] ,[DicInfoGame objectForKey:@"Date"],@"0",[NSString stringWithFormat:@"%@",[CanSaiRenShu JSONString]],[[NSUserDefaults standardUserDefaults] objectForKey:@"TheTeamMoney"], nil]];
        
        }


[fmdbs close];
[fmdbs release];
        return YES;
        
}
    return NO;
}
@end
