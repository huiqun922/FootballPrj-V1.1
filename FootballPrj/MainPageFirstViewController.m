//
//  MainPageFirstViewController.m
//  FootballPrj
//
//  Created by ytt on 12-12-21.
//  Copyright (c) 2012年 ytt. All rights reserved.
//
#import "MainPageFirstViewController.h"
#import "AddTeamViewController.h"
#import "FMDBServers.h"
#import "ShareWithImage.h"
#import "TheOverGame.h"
#import "MainPageAppDelegate.h"



@interface MainPageFirstViewController ()
@property(nonatomic,retain)NSMutableArray *arraySelect;
@property(nonatomic,retain)NSArray *arrayOver;

@end
@implementation MainPageFirstViewController
@synthesize arrayData;
@synthesize arraySelect;
@synthesize First;
@synthesize arrayOver;

-(NSString *)getScore{
    NSString *score=@"上场比分:";
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:50];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
        FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT ID,MyScore,YouScore,Date FROM Bisai  where GameOver = ? order by ID desc",@"YES"];
       while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
            //NSLog(@"%d",[rs intForColumn:@"MyScore"]);
           score= [NSString stringWithFormat:@"上场比分: %@ : %@",[rs stringForColumn:@"MyScore"],[rs stringForColumn:@"YouScore"]];
           [dic setObject:score forKey:@"score"];
           [dic setObject:[rs stringForColumn:@"Date"] forKey:@"Date"];
           [dic setObject:[rs stringForColumn:@"MyScore"] forKey:@"MyScore"];
           [dic setObject:[rs stringForColumn:@"ID"] forKey:@"ID"];

           [dic setObject:[rs stringForColumn:@"YouScore"] forKey:@"YouScore"];

           [array addObject:dic];
           

        }
        [rs close];
    }
    [fmdbs close];
    [fmdbs release];
    
    array=[NSMutableArray arrayWithArray:[self ArrayPaiXu:array]];
    if ([array count]>0) {
    self.arrayOver=[NSArray arrayWithObjects:[[array objectAtIndex:0] objectForKey:@"ID"],[[array objectAtIndex:0] objectForKey:@"MyScore"], [[array objectAtIndex:0] objectForKey:@"YouScore"],nil];
    return [[array objectAtIndex:0] objectForKey:@"score"];
    }else
        return @"暂无比赛";
}
-(NSArray *)ArrayPaiXu:(NSArray *)array{
    
    
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
                     
                     return (NSComparisonResult)NSOrderedAscending;
                 }
                 else
                 {
                     return (NSComparisonResult)NSOrderedDescending;
                 }
                 return (NSComparisonResult)NSOrderedSame;
             }];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self getScore];
        self.navigationItem.title =@"球队管理";
        self.tabBarItem.title=@"球队管理";
        //self.tabBarItem.badgeValue
        self.tabBarItem.image = [UIImage imageNamed:@"球队管理.png"];
        
        //[self.navigationItem.backBarButtonItem setStyle:UIBarButtonItemStyleDone];
        self.navigationItem.title =@"球队管理";        
        
        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"返回_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"  返回" forState:UIControlStateNormal];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonleft addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.leftBarButtonItem=left;
        
        UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonright setBackgroundImage:[UIImage imageNamed:@"下拉按钮_2.png"] forState:UIControlStateNormal];
        [buttonright setFrame:CGRectMake(0, 0, 36.5, 36.5)];
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
    //UIBarButtonItem *buttonBar=(UIBarButtonItem *)sender;
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:13];
    if(!view){
        
        [UIView beginAnimations:@"Move" context:NULL];// 動畫開始
    
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; // 動畫時間曲線
        [UIView setAnimationDuration:0.5];// 動畫時間
        //view.hidden=NO;
        [UIView commitAnimations];// 動畫結束
        [self settheshowView];
        
        
    }else{
        
        [UIView beginAnimations:@"Move" context:NULL];// 動畫開始
        [UIView setAnimationDuration:0.5f];// 動畫時間
        //view.hidden=YES;
        [UIView commitAnimations];// 動畫結束
        UIView *view1=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:13];
        [view1 removeFromSuperview];
    }

    
}
-(void)viewWillAppear:(BOOL)animated{
    
    UIView *view=(UIView *)[self.view viewWithTag:10];
    [view setFrame:CGRectMake(240, -120, 70, 0)];
    
    NSString *stringyue= [NSString stringWithFormat:@"基金余额: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"TheTeamMoney"]];
    self.arrayData=[NSArray arrayWithObjects:[self getScore],stringyue,@"球员列表:",nil];
    [self getDateFrompPlist];
    [self.theTableView reloadData];
    self.tabBarItem.title=@"球队管理";

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    CGFloat iphone5=0;
    if (iPhone5) {
        iphone5=30;
    }
    
    //[showView release];
    UIView *view=[[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.theTableView setBackgroundView:view];
    [self.theTableView setBackgroundColor:[UIColor clearColor]];
    [view release];
    self.theImageView=[[[UIImageView alloc] initWithFrame:CGRectMake(10.0,15.0, 80, 80)] autorelease];
    self.theImageView.layer.masksToBounds=YES;
    self.theImageView.layer.cornerRadius=5.5;
    [self.view addSubview:self.theImageView];
    
    if (iPhone5) {
        [self.theImageView setFrame:CGRectMake(10.0, 15.0, 100, 100)];
        [self.labeltime setFrame:CGRectMake(120.0, 10.0, 220.0, 30.0)];
        [self.labeltime setFont:[UIFont boldSystemFontOfSize:16]];
        [self.labeltime setTextColor:[UIColor whiteColor]];
        [self.labelheader setFrame:CGRectMake(120.0, 50.0, 220.0, 30.0)];
        [self.labelheader setTextColor:[UIColor whiteColor]];
        [self.labelheader setFont:[UIFont boldSystemFontOfSize:16]];
        [self.money setFont:[UIFont boldSystemFontOfSize:16]];
        [self.money setFrame:CGRectMake(120.0,90.0, 220.0, 30.0)];
        [self.money setTextColor:[UIColor whiteColor]];
    }
    else{
        [self.labeltime setFrame:CGRectMake(100.0, 10.0, 220.0, 30.0)];
        [self.labeltime setTextColor:[UIColor whiteColor]];
        [self.labelheader setFrame:CGRectMake(100.0, 40.0, 220.0, 30.0)];
        [self.labelheader setTextColor:[UIColor whiteColor]];
        [self.money setFrame:CGRectMake(100.0, 70.0, 220.0, 30.0)];
        [self.money setTextColor:[UIColor whiteColor]];
    }
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 103.0+iphone5, 320.0, 10.0)];
    [imageView setImage:[UIImage imageNamed:@"分割线_阴影.png"]];
    [self.view addSubview:imageView];
    [imageView release];
    
    CGRect Textrect=self.TeamJianjie.frame;
    CGRect tablerect=self.theTableView.frame;

    [self.TeamJianjie setFrame:CGRectMake(Textrect.origin.x, Textrect.origin.y+iphone5, Textrect.size.width, Textrect.size.height)];
    [self.TeamJianjie setBackgroundColor:[UIColor clearColor]];
    [self.TeamJianjie setTextColor:[UIColor whiteColor]];
    [self.theTextImage setFrame:CGRectMake(Textrect.origin.x, Textrect.origin.y+iphone5, Textrect.size.width, Textrect.size.height+iphone5)];
    self.theTextImage.layer.masksToBounds=YES;
    self.theTextImage.layer.cornerRadius=2.2;
    [self.theTableView setFrame:CGRectMake(tablerect.origin.x, tablerect.origin.y+(iphone5*2), tablerect.size.width, tablerect.size.height+30)];
    
    
    if (First) {
    [self performSelector:@selector(AddTeam:)];
    }
}
-(void)settheshowView{
    UIView *showView=[[UIView alloc] initWithFrame:CGRectMake(235.0,19.0, 81.5, 137.0)];
    [showView setBackgroundColor:[UIColor clearColor]];
    showView.layer.contents=(id)[UIImage imageNamed:@"下拉菜单.png"].CGImage;
    showView.tag=13;
    
    UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonright setBackgroundImage:[UIImage imageNamed:@"下拉按钮_2.png"] forState:UIControlStateNormal];
    [buttonright setFrame:CGRectMake(43,3, 36.5, 36.5)];
    [buttonright.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonright addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:buttonright];
    
    UIButton *buttonAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"编辑" forState:UIControlStateNormal];
    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonAdd.titleLabel setTextColor:[UIColor yellowColor]];
    [buttonAdd addTarget:self action:@selector(AddTeam:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAdd setFrame:CGRectMake(10, 50, 61.5, 30)];
    [showView addSubview:buttonAdd];
    
    UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShare setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(ShareTeam:) forControlEvents:UIControlEventTouchUpInside];
    [buttonShare.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonShare setFrame:CGRectMake(10, 92, 61.5, 30)];
    [showView addSubview:buttonShare];
    [[UIApplication sharedApplication].keyWindow addSubview:showView];
   // [self.view addSubview:showView];
    [showView release];
    
}

-(void)AddTeam:(id)sender{
     AddTeamViewController *addteamView=[[AddTeamViewController alloc] init];
    [addteamView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addteamView animated:YES];
    [addteamView release];
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:13];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];
    
}
-(void)ShareTeam:(id)sender{
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:13];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];;
    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.shareView setTheContent:@"这是我的球队，敢于一战否"];
    [app.shareView getImageFromView:self.view];
    [app.shareView simpleShareAllButtonClickHandler:self.tabBarController.view];
    //[share release];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_theNavBar release];
    [arrayData release];
    [arraySelect release];
    [_theImageView release];
    [_theDuihui release];
    [_labeltime release];
    [_labelheader release];
    [_money release];
    [_TeamJianjie release];
    [_theTableView release];
    [_theTextImage release];
    [arrayOver release];
    [super dealloc];
}
- (void)viewDidUnload {
    NSLog(@"viewDidUnload");
    [self setTheNavBar:nil];
    [self setTheImageView:nil];
    [self setTheDuihui:nil];
    [self setLabeltime:nil];
    [self setLabelheader:nil];
    [self setMoney:nil];
    [self setTeamJianjie:nil];
    [self setTheTableView:nil];
    [self setTheTextImage:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:13];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];
    [super viewWillDisappear:NO];
}
//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    cell.textLabel.text=[self.arrayData objectAtIndex:indexPath.row];
   // cell.selected=NO;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //cell.selected=YES;
    
    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iPhone5) {
        return 45.0;
    }
    return 36.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    switch (indexPath.row) {
        case 0:{

            if ([self.arrayOver count]>1) {
                
                NSString *string=@"TheOverGame";
                if (iPhone5) {
                    string=@"TheOverGame_i5";
                }
                
            TheOverGame *overGame=[[TheOverGame alloc] initWithNibName:string bundle:nil];
            [overGame setBiSaiID:[self.arrayOver objectAtIndex:0]];
            overGame.ScoreW=[[self.arrayOver objectAtIndex:1] intValue];
            overGame.ScoreD=[[self.arrayOver objectAtIndex:2] intValue];
            
            [overGame setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:overGame animated:YES];
            [overGame release];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无完成的比赛" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }break;
        case 1:{
            self.tabBarController.selectedIndex=3;
        }break;
        case 2:
            self.tabBarController.selectedIndex=2;
            break;
            
        default:
            return;
            break;
    }
        //self.tabBarController.selectedIndex=2;
    
}
-(void)getDateFrompPlist{
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
    
   // NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:@"duihui.png"];
    UIImage *image=[UIImage imageWithContentsOfFile:savedImagePath];

    if (image==nil||image==NULL) {
        [self.theImageView setImage:[UIImage imageNamed:@"队徽图片01.png"]];
    }else{
        [self.theImageView setImage:[UIImage imageWithContentsOfFile:savedImagePath]];
    }
    self.arraySelect = [NSMutableArray arrayWithContentsOfFile:plistPath];
    if ([self.arraySelect count]<1) {
        self.arraySelect=[NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",nil];
    }
   
self.title=[self.arraySelect objectAtIndex:0];//队名
    
self.labelheader.text=[NSString stringWithFormat:@"队长 :%@",[self.arraySelect objectAtIndex:2]];//队长
self.labeltime.text=[NSString stringWithFormat:@"成立时间 :%@",[self.arraySelect objectAtIndex:1]];//成立时间
self.money.text=[NSString stringWithFormat:@"财务 :%@",[self.arraySelect objectAtIndex:3]];//财务
self.TeamJianjie.text=[self.arraySelect objectAtIndex:4];//球队简介

}

- (IBAction)HidenView:(id)sender {
    
    UIView *view=(UIView *)[self.view viewWithTag:10];
    
    [UIView beginAnimations:@"Move" context:NULL];// 動畫開始
    [UIView setAnimationDuration:0.5f];// 動畫時間
    [view setFrame:CGRectMake(240, -120, 70, 0)];
    [UIView commitAnimations];// 動畫結束

    
}
@end
