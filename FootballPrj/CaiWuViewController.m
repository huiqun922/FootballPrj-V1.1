//
//  CaiWuViewController.m
//  FootballPrj
//
//  Created by mokbid on 13-5-8.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "CaiWuViewController.h"
#import "CaiWuInfoView.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "FMDBServers.h"
#import "ShareWithImage.h"
#import "MainPageAppDelegate.h"

@interface CaiWuViewController (){
    BOOL Personal;
    BOOL paixu;
}
@property(nonatomic,retain)NSMutableArray *arrayDate;
@end

@implementation CaiWuViewController
@synthesize arrayDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
             self.title=@"财务管理";
        self.navigationItem.title=@"球队财务管理";
        self.tabBarItem.image = [UIImage imageNamed:@"财务管理.png"];

        
        self.arrayDate=[NSMutableArray arrayWithCapacity:50];
        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"返回_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"  返回" forState:UIControlStateNormal];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonleft addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.leftBarButtonItem=left;
        [left release];
        
        UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonShare setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
        [buttonShare setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonShare addTarget:self action:@selector(ShareCaiwu:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonShare];
        self.navigationItem.rightBarButtonItem=right;
        [right release];
        


    }
    return self;
}
-(void)ShareCaiwu:(id)sender{
    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.shareView setTheContent:@"我在用草根足球管家管理我的球队财务"];
    [app.shareView getImageFromView:self.view];
    [app.shareView simpleShareAllButtonClickHandler:self.tabBarController.view];
}
-(void)ComeBack:(id)sender{
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    
}
-(void)viewWillAppear:(BOOL)animated{    
    
    if (Personal) {
        self.arrayDate=[NSMutableArray arrayWithArray:[self GetPersonalCaiWu]];
        NSLog(@"Personal");
        
        
    }else{
        
    self.arrayDate=[NSMutableArray arrayWithArray:[self GetTeamCaiWu]];
        NSLog(@"Team");
   
    }
    [self.theTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.arrayDate=[NSMutableArray arrayWithArray:[self GetTeamCaiWu]];
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.theTableView setBackgroundView:view];
    [self.theTableView setBackgroundColor:[UIColor clearColor]];

    [view release];
    [self.theTableView setFrame:CGRectMake(0.0, 50.0, 320.0,405.0)];
}
//tableview datasoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayDate count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idString=@"idString";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
        UILabel *labelName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
        labelName.tag=1;
        [labelName setBackgroundColor:[UIColor clearColor]];
        //[labelName setTextAlignment:UITextAlignmentCenter];
        [labelName setFont:[UIFont systemFontOfSize:14]];

        labelName.numberOfLines=2;
        [labelName sizeThatFits:CGSizeMake(80, 45)];
        [cell.contentView addSubview:labelName];
        [labelName release];
        
        UILabel *labelChu=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 50, 45)];
        labelChu.tag=2;
        [labelChu setFont:[UIFont systemFontOfSize:14]];
        [labelChu setBackgroundColor:[UIColor clearColor]];
        [labelChu setTextAlignment:UITextAlignmentCenter];
        [cell.contentView addSubview:labelChu];
        [labelChu release];
        
        UILabel *labelJinE=[[UILabel alloc] initWithFrame:CGRectMake(140, 0, 50, 45)];
        labelJinE.tag=3;
        [labelJinE setFont:[UIFont systemFontOfSize:14]];

        [labelJinE setBackgroundColor:[UIColor clearColor]];
        [labelJinE setTextAlignment:UITextAlignmentCenter];
        labelJinE.numberOfLines=0;
        //[labelJinE sizeToFit];
        [cell.contentView addSubview:labelJinE];
        [labelJinE release];
        
        UILabel *labelTime=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 140, 45)];
        [labelTime setFont:[UIFont systemFontOfSize:14]];

        labelTime.tag=4;
        [labelTime setBackgroundColor:[UIColor clearColor]];
        [labelTime setTextAlignment:UITextAlignmentCenter];
        [labelTime setNumberOfLines:0];
        //[labelTime sizeToFit];
        [cell.contentView addSubview:labelTime];
        [labelTime release];
        
    }
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    if (Personal) {
        UILabel *labelName=(UILabel *)[cell.contentView viewWithTag:1];

        FMDBServers *fmdbs=[[FMDBServers alloc] init];
        if ([fmdbs OpenDatabase]) {
            NSString *ID=[[self.arrayDate objectAtIndex:indexPath.row] objectForKey:@"ID"];
            
            NSString *Name= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[ID intValue]]];
            labelName.text=Name;

        }
        [fmdbs close];
        [fmdbs release];
        
        
        UILabel *labelChu=(UILabel *)[cell.contentView viewWithTag:2];
        labelChu.text=[NSString stringWithFormat:@"%@ 元",[[self.arrayDate objectAtIndex:indexPath.row] objectForKey:@"Money"]] ;
        
        UILabel *labelJinE=(UILabel *)[cell.contentView viewWithTag:3];
        labelJinE.text=[NSString stringWithFormat:@"%@ 元",[[self.arrayDate objectAtIndex:indexPath.row] objectForKey:@"HandedMoney"]];
        //labelJinE.text=@"000000";
        
        
        UILabel *labelTime=(UILabel *)[cell.contentView viewWithTag:4];
        labelTime.text=[[self.arrayDate objectAtIndex:indexPath.row] objectForKey:@"Date"];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;

        return cell;
        
    }
    cell.textLabel.text=[[self.arrayDate objectAtIndex:indexPath.row
                         ] objectForKey:@"date"];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{ //if(Personal)
    return 36.0f;
//else return 0.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
        
       // topView.layer.contents=(id)[UIImage imageNamed:@"表格部分TITLE"].CGImage;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8.0, 0.0, 304, 35)];
        [imageView setImage:[UIImage imageNamed:@"表格部分TITLE"]];
        imageView.layer.masksToBounds=YES;
        imageView.layer.cornerRadius=5.5;
        [topView addSubview:imageView];
        [imageView release];
        if (Personal) {
    
    UILabel *labelName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelName.text=@"姓名";
        //[labelName setTextColor:[UIColor whiteColor]];
        [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setTextAlignment:UITextAlignmentCenter];
        [labelName setFont:[UIFont systemFontOfSize:14]];
//        labelName.numberOfLines=0;
//        [labelName sizeToFit];
    [topView addSubview:labelName];
    [labelName release];
    
    UILabel *labelChu=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 30)];
    labelChu.text=@"剩余金额";
        [labelChu setBackgroundColor:[UIColor clearColor]];
        //[labelChu setTextColor:[UIColor whiteColor]];
        [labelChu setFont:[UIFont systemFontOfSize:14]];
    [labelChu setTextAlignment:UITextAlignmentCenter];
    [topView addSubview:labelChu];
    [labelChu release];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(80, 0, 60, 30)];
            [button addTarget:self action:@selector(CaiWUPaixu:) forControlEvents:UIControlEventTouchUpInside];
            [topView addSubview:button];
            [button release];
    
    UILabel *labelJinE=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 60, 30)];
    labelJinE.text=@"上次缴纳金额";
    [labelJinE setBackgroundColor:[UIColor clearColor]];
       // [labelJinE setTextColor:[UIColor whiteColor]];
        [labelJinE setFont:[UIFont systemFontOfSize:14.0]];
    [labelJinE setTextAlignment:UITextAlignmentCenter];
        labelJinE.numberOfLines=0;
    [labelJinE sizeToFit];
    [topView addSubview:labelJinE];
    [labelJinE release];
    
    UILabel *labelTime=[[UILabel alloc] initWithFrame:CGRectMake(240, 0, 60, 30)];
    labelTime.text=@"上次缴纳时间";
    [labelTime setBackgroundColor:[UIColor clearColor]];
       // [labelTime setTextColor:[UIColor whiteColor]];
        [labelTime setFont:[UIFont systemFontOfSize:14]];
    [labelTime setTextAlignment:UITextAlignmentCenter];
        [labelTime setNumberOfLines:0];
    [labelTime sizeToFit];
    [topView addSubview:labelTime];
    [labelTime release];
        }else{
            
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            
            NSString *TheMoney=[NSString stringWithFormat:@"当前余额:%@ 元",[userDefaults objectForKey:@"TheTeamMoney"]];
            UILabel *labelTime=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 30)];
            labelTime.text=TheMoney;
            [labelTime setBackgroundColor:[UIColor clearColor]];
            // [labelTime setTextColor:[UIColor whiteColor]];
            [labelTime setFont:[UIFont systemFontOfSize:17]];
            [labelTime setTextAlignment:UITextAlignmentLeft];
//            [labelTime setNumberOfLines:0];
//            [labelTime sizeToFit];
            [topView addSubview:labelTime];
            [labelTime release];
        }
    
        return topView;
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CaiWuInfoView *caiwuInfo=[[CaiWuInfoView alloc] init];
    [caiwuInfo setDefaultTableView:[self.arrayDate objectAtIndex:indexPath.row] Personal:Personal];
    [caiwuInfo setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:caiwuInfo animated:YES];
    [caiwuInfo release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_theNavBar release];
    [arrayDate release];
    [_theTableView release];
    [_PersonalButton release];
    [_TeamButton release];
    [super dealloc];
}
- (IBAction)SelectCaiwu:(id)sender {
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {   Personal=NO;
                self.arrayDate=[NSMutableArray arrayWithArray:[self GetTeamCaiWu]];
        }
            break;
        case 1:{
            Personal=YES;
            self.arrayDate=[NSMutableArray arrayWithArray:[self GetPersonalCaiWu]];
        }
            break;
        default:
            break;
    }
    [self.theTableView reloadData];
}
- (void)viewDidUnload {
    [self setTheTableView:nil];
    [self setPersonalButton:nil];
    [self setTeamButton:nil];
    [super viewDidUnload];
}

-(NSMutableArray *)GetPersonalCaiWu{
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:50];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
    FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT * FROM CaiWu"];
    while ([rs next]) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
        [dic setValue:[rs stringForColumn:@"Name"] forKey:@"Name"];
        [dic setValue:[rs stringForColumn:@"Money"] forKey:@"Money"];
        [dic setValue:[rs stringForColumn:@"HandedMoney"] forKey:@"HandedMoney"];
        [dic setValue:[rs stringForColumn:@"Date"] forKey:@"Date"];
        [dic setValue:[rs stringForColumn:@"MemberID"] forKey:@"MemberID"];
        [dic setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
        [array addObject:dic];
    }
    
    [rs close];

    }
    [fmdbs close];
    [fmdbs release];
    NSLog(@"%@",array);
    return array;
}
-(NSMutableArray *)GetTeamCaiWu{
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:50];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
        FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT * FROM TeamCaiwu"];
        while ([rs next]) {
            //BiSaiID,date,renJunXiaoFei,CanJiaRenShu,yuE
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
            [dic setValue:[rs stringForColumn:@"BiSaiID"] forKey:@"BiSaiID"];
            [dic setValue:[rs stringForColumn:@"date"] forKey:@"date"];
            [dic setValue:[rs stringForColumn:@"renJunXiaoFei"] forKey:@"renJunXiaoFei"];
            [dic setValue:[rs stringForColumn:@"CanJiaRenShu"] forKey:@"CanJiaRenShu"];
            [dic setValue:[rs stringForColumn:@"yuE"] forKey:@"yuE"];
            [array addObject:dic];
        }
        
        [rs close];
        
    }
    [fmdbs close];
    [fmdbs release];
    NSLog(@"%@",array);
    return array;
}
- (IBAction)SelectPersonal:(UIButton *)sender {
    self.navigationItem.title=@"个人财务管理";
    [self.TeamButton setBackgroundImage:[UIImage imageNamed:@"财务管理_1.png"] forState:UIControlStateNormal];
    [self.PersonalButton setBackgroundImage:[UIImage imageNamed:@"财务管理_2.png"] forState:UIControlStateNormal];
    Personal=YES;
    self.arrayDate=[NSMutableArray arrayWithArray:[self GetPersonalCaiWu]];
    [self.theTableView reloadData];
    
}

- (IBAction)SelectTeam:(UIButton *)sender {
    self.navigationItem.title=@"球队财务管理";
    [self.TeamButton setBackgroundImage:[UIImage imageNamed:@"财务管理_2.png"] forState:UIControlStateNormal];
    [self.PersonalButton setBackgroundImage:[UIImage imageNamed:@"财务管理_1.png"] forState:UIControlStateNormal];
    Personal=NO;
    self.arrayDate=[NSMutableArray arrayWithArray:[self GetTeamCaiWu]];
    [self.theTableView reloadData];
}
-(void)CaiWUPaixu:(id)sender{
   // [[self.arrayDate objectAtIndex:indexPath.row] objectForKey:@"HandedMoney"]];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"HandedMoney" ascending:paixu];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    self.arrayDate = [NSMutableArray arrayWithArray:[self.arrayDate sortedArrayUsingDescriptors:sortDescriptors] ];
    [sorter release];
    [self.theTableView reloadData];
    
    if (paixu) {
        paixu=NO;
    }else{
        paixu=YES;

    }
    
}
@end
