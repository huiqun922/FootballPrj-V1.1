//
//  TheOverGame.m
//  FootballPrj
//
//  Created by mokbid on 13-5-14.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

//arrayTable 每一个元素都一个字典组成（Shoot,Assist,Time）,Shoot和Assist也是字典，包括进球和助攻球员的各项信息。



#import "TheOverGame.h"
#import "FMDBServers.h"
#import "JSONKit.h"
#import "ShareWithImage.h"
#import "TheNextGame.h"
#import "MainPageAppDelegate.h"

@interface TheOverGame (){
    NSInteger alter;
   // NSInteger ScoreW;
  //  NSInteger ScoreD;
}
@property(nonatomic,retain)UIPickerView *thePickerView;
@property(nonatomic,retain)NSMutableArray *arrayTabel;  //我方进球
@property(nonatomic,retain)NSMutableArray *arrayPicker;  //对方进球
@property(nonatomic,retain)NSMutableDictionary *dicInfo;


@end

@implementation TheOverGame
@synthesize thePickerView;
@synthesize arrayPicker,arrayTabel;
@synthesize BiSaiID;
@synthesize dicInfo;
@synthesize ScoreD,ScoreW;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrayTabel=[NSMutableArray arrayWithCapacity:50];
        self.arrayPicker=[NSMutableArray arrayWithCapacity:50];
        ScoreD=0;
        ScoreW=0;

        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"返回_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"  返回" forState:UIControlStateNormal];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonleft addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.hidesBackButton = YES;
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SelectTheMore:(id)sender{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:16];
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
       // view.hidden=YES;
        [UIView commitAnimations];// 動畫結束
        UIView *view1=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:16];
        [view1 removeFromSuperview];
    }


    
}

-(void)viewWillAppear:(BOOL)animated{
//    UIView *view=(UIView *)[self.view viewWithTag:10];
//    [view setFrame:CGRectMake(240, -120, 70, 0)];
    [super viewWillAppear:NO];
    
    self.title=[NSString stringWithFormat:@"%d : %d",ScoreW,ScoreD];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
        int theID=[BiSaiID intValue];
        if([fmdbs.dbs  executeUpdate:@"UPDATE  Bisai set MyScore =? , YouScore =? where ID = ?",[NSString stringWithFormat:@"%d",ScoreW],[NSString stringWithFormat:@"%d",ScoreD],[NSNumber numberWithInt:theID]]){
            NSLog(@"SCORE  SUCCESS %@ %@ %d",[NSString stringWithFormat:@"%d",ScoreW],[NSString stringWithFormat:@"%d",ScoreD],theID);
        }
        }
    [fmdbs close];
    [fmdbs release];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];

    self.labelWo.text=[NSString stringWithFormat:@"我方: %@",[[NSArray arrayWithContentsOfFile:plistPath] objectAtIndex:0]];
    
    
    FMDBServers *fmdbsb=[[FMDBServers alloc] init];
    if ([fmdbsb OpenDatabase]) {
       	NSString *jsonString = [fmdbsb.dbs stringForQuery:@"SELECT Enemy FROM Bisai WHERE ID = ?",self.BiSaiID];
        self.labelDui.text=[NSString stringWithFormat:@"对方: %@",jsonString];;

    }
    [fmdbsb close];
    [fmdbsb release];
        
    self.arrayTabel=[NSMutableArray arrayWithArray:[self ArrayPaiXu:self.arrayTabel]];
    self.arrayPicker=[NSMutableArray arrayWithArray:[self ArrayPaiXu:self.arrayPicker]];
    [self.WFtabelView reloadData];
    [self.DFtableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
       	NSString *jsonString = [fmdbs.dbs stringForQuery:@"SELECT MemberID FROM JinQiu WHERE BisaiID = ?",self.BiSaiID];
        self.dicInfo=[NSMutableDictionary dictionaryWithDictionary:[jsonString objectFromJSONString]];
    }
    [fmdbs close];
    [fmdbs release];
    
    self.arrayTabel=[NSMutableArray arrayWithArray:[self.dicInfo objectForKey:@"WoFang"] ];
    
    self.arrayTabel=[NSMutableArray arrayWithArray:[self ArrayPaiXu:[self.dicInfo objectForKey:@"WoFang"]]];
    self.arrayPicker=[NSMutableArray arrayWithArray:[self ArrayPaiXu:[self.dicInfo objectForKey:@"DuiFang"]]];
    
    UIView *view=[[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    view.layer.contents=(id)[UIImage imageNamed:@"黑色半透明蒙版.png"].CGImage;
    [self.WFtabelView setBackgroundView:view];
    UIView *view1=[[UIView alloc] init];
    [view1 setBackgroundColor:[UIColor clearColor]];
    view1.layer.contents=(id)[UIImage imageNamed:@"黑色半透明蒙版.png"].CGImage;
    [self.DFtableView setBackgroundView:view1];
    [view release];
    [view1 release];
    if (!iPhone5) {
    //self.title=[self.dicInfo objectForKey:@"Score"];
    [self.labelWo setTextColor:[UIColor whiteColor]];
    [self.labelDui setTextColor:[UIColor whiteColor]];
    
    [self.WFtabelView setFrame:CGRectMake(10.0, 36.0, 300.0, 200)];
    [self.WFtabelView setBackgroundColor:[UIColor clearColor]];

    //[self.labelDui setFrame:CGRectMake(20.0, 212.0, 102.0, 21.0)];
    [self.buttonDui setFrame:CGRectMake(209.0, 212.0, 101.0, 25.0)];
    [self.DFtableView setFrame:CGRectMake(10.0, 245.0, 300.0, 200.0)];
    [self.DFtableView setBackgroundColor:[UIColor clearColor]];

    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 202.0, 320.0, 10.0)];
    [imageView setImage:[UIImage imageNamed:@"分割线_阴影.png"]];
    [self.view addSubview:imageView];
    [imageView release];
    }else{
        [self.labelWo setTextColor:[UIColor whiteColor]];
        [self.labelDui setTextColor:[UIColor whiteColor]];
        
        [self.WFtabelView setBackgroundColor:[UIColor clearColor]];
        [self.DFtableView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 202.0+42, 320.0, 10.0)];
        [imageView setImage:[UIImage imageNamed:@"分割线_阴影.png"]];
        [self.view addSubview:imageView];
        [imageView release];
    }
   
}
-(void)settheshowView{
    
    UIView *showView=[[UIView alloc] initWithFrame:CGRectMake(235.0,19.0, 81.5, 179.0)];
    [showView setBackgroundColor:[UIColor clearColor]];
    showView.layer.contents=(id)[UIImage imageNamed:@"下拉菜单.png"].CGImage;
    showView.tag=16;
    
    UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonright setBackgroundImage:[UIImage imageNamed:@"下拉按钮_2.png"] forState:UIControlStateNormal];
    [buttonright setFrame:CGRectMake(43,3, 36.5, 36.5)];
    [buttonright.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonright addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:buttonright];
    
    UIButton *buttonAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"参赛人员" forState:UIControlStateNormal];
    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonAdd addTarget:self action:@selector(CanSaiRenYuan:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAdd setFrame:CGRectMake(10, 55, 61.5, 30)];
    [showView addSubview:buttonAdd];
    
    UIButton *buttonDelete=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDelete setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonDelete setTitle:@"删除比赛" forState:UIControlStateNormal];
    [buttonDelete addTarget:self action:@selector(DeleteGame:) forControlEvents:UIControlEventTouchUpInside];
    [buttonDelete.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonDelete.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonDelete setFrame:CGRectMake(10, 97, 61.5, 30)];
    [showView addSubview:buttonDelete];
    
    UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShare setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonShare setTitle:@"分   享" forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(ShareGame:) forControlEvents:UIControlEventTouchUpInside];
    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonShare setFrame:CGRectMake(10, 139, 61.5, 30)];
    [showView addSubview:buttonShare];
    
    
//    UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonShare setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
//    [buttonShare setTitle:@"分  享" forState:UIControlStateNormal];
//    [buttonShare addTarget:self action:@selector(DeleteGame:) forControlEvents:UIControlEventTouchUpInside];
//    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [buttonShare setFrame:CGRectMake(10, 92, 61.5, 30)];
//    [showView addSubview:buttonShare];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:showView];
    // [self.view addSubview:showView];
    [showView release];
    
}
-(void)CanSaiRenYuan:(id)sender{
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:16];
    [view removeFromSuperview];
    
    TheNextGame *nextGame=[[TheNextGame alloc] initWithNibName:@"TheNextGame" bundle:nil];
    [nextGame SetID:self.BiSaiID];
    nextGame.navigationItem.rightBarButtonItem=nil;
    [self.navigationController pushViewController:nextGame animated:YES];
    for (int i=1; i<=32; i++) {
        UIButton *button=(UIButton *)[nextGame.view viewWithTag:i];
        [button setEnabled:NO];
    }
    UIButton *buttonDelete=(UIButton *)[nextGame.view viewWithTag:99];
    [buttonDelete setHidden:YES];
    [nextGame release];
    
    
    
}
-(void)ShareGame:(id)sender{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:16];
    [view removeFromSuperview];

    NSString *jsonString=nil;
    FMDBServers *fmdbsb=[[FMDBServers alloc] init];
    if ([fmdbsb OpenDatabase]) {
       	jsonString = [fmdbsb.dbs stringForQuery:@"SELECT Enemy FROM Bisai WHERE ID = ?",self.BiSaiID];        
    }
    [fmdbsb close];
    [fmdbsb release];
    
    
    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.shareView setTheContent:[NSString stringWithFormat:@"与 %@ 队的这一场比赛，我们酣畅淋漓，怎么一个痛快了得",jsonString]];
    [app.shareView getImageFromView:self.view];
    [app.shareView simpleShareAllButtonClickHandler:self.tabBarController.view];
}
-(void)DeleteGame:(id)sender{
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:16];
    [view removeFromSuperview];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除本场比赛?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];

}
//UIAlertView 委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {

        FMDBServers *fmdbs=[[FMDBServers alloc] init];
        if ([fmdbs OpenDatabase]) {
            [fmdbs.dbs executeUpdate:@"delete from Bisai where ID = ?",[NSNumber numberWithInt:[self.BiSaiID integerValue]]];
            FMResultSet *rs=[fmdbs.dbs executeQuery:@"select MemberID from CanSai where BisaiID = ?",self.BiSaiID];
            if ([rs next]) {
                NSString *changci=[rs stringForColumn:@"MemberID"];
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[changci objectFromJSONString]];
                for (int i=1; i<=32; i++) {
                    NSString *String=  [[dic objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"ID"];
                    int m=[String intValue];
                    if (String!=NULL) {
                        NSString *Score = [fmdbs.dbs stringForQuery:@"SELECT ChangCi FROM User WHERE ID = ?",[NSNumber numberWithInt:m]];
                        int theScore=[Score intValue]-1;
                        [fmdbs.dbs executeUpdate:@"UPDATE User SET ChangCi = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theScore],[NSNumber numberWithInt:m]];
                    }
                }
            }
            [rs close];
            //删除参赛表中数据
            [fmdbs.dbs executeUpdate:@"delete form CanSai where BisaiID = ?",[NSNumber numberWithInt:[self.BiSaiID integerValue]]];
            //删除球队财物表中数据
            [fmdbs.dbs executeUpdate:@"delete from TeamCaiwu where BisaiID = ?",[NSNumber numberWithInt:[self.BiSaiID integerValue]]];
        }
        [fmdbs close];
        [fmdbs release];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSLog(@"cacnle");
    }
}

-(NSArray *)ArrayPaiXu:(NSArray *)array{
    
   return  [array sortedArrayUsingComparator:^(id obj1,id obj2)
     {
         NSDictionary *dic1 = (NSDictionary *)obj1; 
         NSDictionary *dic2 = (NSDictionary *)obj2;
         NSNumber *num1 = (NSNumber *)[[dic1 objectForKey:@"Time"]objectForKey:@"Name"];
         NSNumber *num2 = (NSNumber *)[[dic2 objectForKey:@"Time"] objectForKey:@"Name"];
         if ([num1 floatValue] < [num2 floatValue])
         {
             return (NSComparisonResult)NSOrderedAscending;
         }
         else
         {
             return (NSComparisonResult)NSOrderedDescending; 
         }
         return (NSComparisonResult)NSOrderedSame;
     }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    [self setThePickerView:nil];
    [self setWFtabelView:nil];
    [self setDFtableView:nil];
    [self setLabelWo:nil];
    [self setLabelDui:nil];
    [self setButtonWo:nil];
    [self setButtonDui:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:16];
    [view removeFromSuperview];
    
    [super viewWillDisappear:NO];
}
-(void)dealloc{
    [dicInfo release];
    [BiSaiID release];
    [arrayTabel release];
    [arrayPicker release];
    [_WFtabelView release];
    [_DFtableView release];
    [_labelWo release];
    [_labelDui release];
    [_buttonWo release];
    [_buttonDui release];
    [super dealloc];
}
//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [self.arrayTabel count];
    }
    return [self.arrayPicker count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idStringGame=@"idStringGame";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idStringGame];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStringGame] autorelease];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 50.0f, 45.0f)];
        label.backgroundColor=[UIColor clearColor];
        label.tag=19;
        label.textAlignment=UITextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:label];
        [label release];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(3.0, 12.5, 20.0, 20.0)];
        [imageView setImage:[UIImage imageNamed:@"time.png"]];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(80.0f, 0.0f, 80.0f, 45.0f)];
        label1.backgroundColor=[UIColor clearColor];
        label1.tag=20;
        //label1.textAlignment=UITextAlignmentCenter;
        label1.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:label1];
        [label1 release];
        
        UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(55.0, 12.5, 25.0,20.0)];
        [imageView1 setImage:[UIImage imageNamed:@"A-进球.png"]];
        [cell.contentView addSubview:imageView1];
        [imageView1 release];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(180.0f, 0.0f, 80.0f, 45.0f)];
        label2.backgroundColor=[UIColor clearColor];
        label2.tag=21;
        //label2.textAlignment=UITextAlignmentCenter;
        label2.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:label2];
        [label2 release];
        UIImageView *imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(160.0, 12.5, 20.0, 20.0)];
        [imageView2 setImage:[UIImage imageNamed:@"A-点球.png"]];
        [cell.contentView addSubview:imageView2];
        [imageView2 release];
        
    }
    UIImage *image = [UIImage imageNamed:@"分享等_button1.png"];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
        

    if (tableView.tag==1) {
        
        NSString *ShootID=[[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Shoot"] objectForKey:@"ID"];
        
        NSString *AssistId=[[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Assist"] objectForKey:@"ID"];
        
        NSString *ShootName= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[ShootID intValue]]];
        NSString *AssistName= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[AssistId intValue]]];
        
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:19];
    label.text=[[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Time"] objectForKey:@"Name"];
    UILabel *label1=(UILabel *)[cell.contentView viewWithTag:20];
        if (ShootName==nil) {
    label1.text=[[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Shoot"] objectForKey:@"Name"];
        }else{
    label1.text=ShootName;
        }
    UILabel *label2=(UILabel *)[cell.contentView viewWithTag:21];
        if (AssistName==nil) {
            label2.text=[[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Assist"] objectForKey:@"Name"];
        }else{
    label2.text=AssistName;
        }
    }else{
        UILabel *label=(UILabel *)[cell.contentView viewWithTag:19];
        label.text=[[[self.arrayPicker objectAtIndex:indexPath.row] objectForKey:@"Time"] objectForKey:@"Name"];
        UILabel *label1=(UILabel *)[cell.contentView viewWithTag:20];
        label1.text=[[[self.arrayPicker objectAtIndex:indexPath.row] objectForKey:@"Shoot"] objectForKey:@"Name"];
        
    }
    }
    [fmdbs close];
    [fmdbs release];
    
    // NSLog(@"%@",[self.arraySelect objectAtIndex:indexPath.row]);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int m=tableView.tag-1;
    alter=indexPath.row;
    TheScoreInfoView *theScore=[[TheScoreInfoView alloc] initWithNibName:@"TheScoreInfoView" bundle:nil Index:m];
    theScore.TheDelegate=self;
    theScore.Add=NO;
    if (m==1) {
    [theScore setArrayTabel:[NSMutableArray arrayWithObjects:[[self.arrayPicker objectAtIndex:indexPath.row] objectForKey:@"Time"],[[self.arrayPicker objectAtIndex:indexPath.row] objectForKey:@"Shoot"],[[self.arrayPicker objectAtIndex:indexPath.row] objectForKey:@"Assist"], nil]];
    }else{
    [theScore setArrayTabel:[NSMutableArray arrayWithObjects:[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Time"],[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Shoot"],[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Assist"], nil]];
    }
    
    [self.navigationController pushViewController:theScore animated:YES];
    [theScore release];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}


- (IBAction)AddDuiFang:(id)sender {
    TheScoreInfoView *theScore=[[TheScoreInfoView alloc] initWithNibName:@"TheScoreInfoView" bundle:nil Index:1];
    theScore.TheDelegate=self;
    
    [self.navigationController pushViewController:theScore animated:YES];
    [theScore release];
}

- (IBAction)AddWoFang:(id)sender {
        TheScoreInfoView *theScore=[[TheScoreInfoView alloc] initWithNibName:@"TheScoreInfoView" bundle:nil Index:0];
    theScore.TheDelegate=self;
    [self.navigationController pushViewController:theScore animated:YES];
    [theScore release];
}
//TheScoreInfoDelegate
-(void)TheDicInfo:(NSArray *)array Index:(NSInteger)index Score:(NSInteger)score TheIDArray:(NSArray *)arrayID{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:[array objectAtIndex:0] forKey:@"Time"];
    [dic setObject:[array objectAtIndex:1] forKey:@"Shoot"];
    [dic setObject:[array objectAtIndex:2] forKey:@"Assist"];
    switch (index) {
        case 0:
        {
            //我方添加进球
            [self.arrayTabel addObject:dic];
            [self.WFtabelView reloadData];
            [self UpdateMember:array];
            if (score>0) {
                ScoreW=ScoreW+1;
            }else{
                ScoreD=ScoreD+1;
            }
            
        }
            break;
        case 1:{
            //对方添加进球
            [self.arrayPicker addObject:dic];
            [self.DFtableView reloadData];
            if (score>0) {
                ScoreD=ScoreD+1;
            }else{
                ScoreW=ScoreW+1;
            }

        }
            break;
        default:
            break;
    }
    [self UpdateJinQiu:nil];
    
}
//更改进球
-(void)UpdateJinQiu:(NSArray *)array Index:(NSInteger)index Score:(NSInteger)score{
        [self SetScore:index Score:score];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:[array objectAtIndex:0] forKey:@"Time"];
    [dic setObject:[array objectAtIndex:1] forKey:@"Shoot"];
    [dic setObject:[array objectAtIndex:2] forKey:@"Assist"];
    
    switch (index) {
        case 0:
        {
            NSDictionary *dicUpdate=[NSDictionary dictionaryWithDictionary:[self.arrayTabel objectAtIndex:alter]];
           [self UpdateMemberWithSome:dicUpdate];//更改进球信息，下删除原来进球的信息
            [self.arrayTabel replaceObjectAtIndex:alter withObject:dic];
            [self.WFtabelView reloadData];//再添加新的进球信息
            [self UpdateMember:array];
            
            
            
        }
            break;
            case 1:
        {
            [self.arrayPicker replaceObjectAtIndex:alter withObject:dic];
            [self.DFtableView reloadData];
        }
            break;
        default:
            break;
    }
        [self UpdateJinQiu:nil];
}
//删除进球
-(void)DeleteJinQiu:(NSArray *)array Index:(NSInteger)index Score:(NSInteger)score{
    [self DeleteScore:index Score:score];
    if (index==0) {
        NSDictionary *dicUpdate=[NSDictionary dictionaryWithDictionary:[self.arrayTabel objectAtIndex:alter]];
        [self UpdateMemberWithSome:dicUpdate];//更改进球信息，下删除原来进球的信息
        
        [self.arrayTabel removeObjectAtIndex:alter];
        [self.WFtabelView reloadData];
    }else{
        [self.arrayPicker removeObjectAtIndex:alter];
        [self.DFtableView reloadData];
    }

    [self UpdateJinQiu:nil];

}
-(void)UpdateJinQiu:(NSArray *)array{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
    [dic setObject:self.arrayTabel forKey:@"WoFang"];
    [dic setObject:self.arrayPicker forKey:@"DuiFang"];
    [dic setObject:@"0:0" forKey:@"Score"];
    
    NSArray *arrayJson=[NSArray arrayWithObject:[dic JSONString]];
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
        if([fmdbs  UpdateDataWithIndex:3 UpdateData:arrayJson Condition:[BiSaiID intValue]])
            NSLog(@"SUCCESS");
    }
 [fmdbs close];
 [fmdbs release];
    
}
//更改进球信息 添加
-(void)UpdateMember:(NSArray *)array{
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    int theIDShoot=[[[array objectAtIndex:1] objectForKey:@"ID"]intValue];
    int theIDAssist=[[[array objectAtIndex:2] objectForKey:@"ID"]intValue];
    if([fmdbs OpenDatabase]){
         NSString *Score = [fmdbs.dbs stringForQuery:@"SELECT JinQiu FROM User WHERE ID = ?",[NSNumber numberWithInt:theIDShoot]];
        int theScore=[Score intValue]+1;
        [fmdbs.dbs executeUpdate:@"UPDATE User SET JinQiu = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theScore],[NSNumber numberWithInt:theIDShoot]];
        
        NSString *Assist = [fmdbs.dbs stringForQuery:@"SELECT ZhuGong FROM User WHERE ID = ?",[NSNumber numberWithInt:theIDAssist]];
        int theAssist=[Assist intValue]+1;
        [fmdbs.dbs executeUpdate:@"UPDATE User SET ZhuGong = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theAssist],[NSNumber numberWithInt:theIDAssist]];
    }
    [fmdbs close];
    [fmdbs release];
    
}
//更改进球信息 删除 
-(void)UpdateMemberWithSome:(NSDictionary *)Dic{
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    int theIDShoot=[[[Dic objectForKey:@"Shoot"] objectForKey:@"ID"]intValue];
    int theIDAssist=[[[Dic objectForKey:@"Assist"] objectForKey:@"ID"]intValue];
    if([fmdbs OpenDatabase]){
        NSString *Score = [fmdbs.dbs stringForQuery:@"SELECT JinQiu FROM User WHERE ID = ?",[NSNumber numberWithInt:theIDShoot]];
        int theScore=[Score intValue]-1;
        [fmdbs.dbs executeUpdate:@"UPDATE User SET JinQiu = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theScore],[NSNumber numberWithInt:theIDShoot]];
        
        NSString *Assist = [fmdbs.dbs stringForQuery:@"SELECT ZhuGong FROM User WHERE ID = ?",[NSNumber numberWithInt:theIDAssist]];
        int theAssist=[Assist intValue]-1;
        [fmdbs.dbs executeUpdate:@"UPDATE User SET ZhuGong = ? WHERE ID = ?",[NSString stringWithFormat:@"%d",theAssist],[NSNumber numberWithInt:theIDAssist]];
    }
    [fmdbs close];
    [fmdbs release];
}

-(void)SetScore:(NSInteger)index Score:(NSInteger)theScore{
    switch (index) {
        case 0:
        {
            NSString *String= [[[self.arrayTabel objectAtIndex:alter] objectForKey:@"Shoot"] objectForKey:@"Name"];
            if ([String isEqualToString:@"乌龙"]) {
                if (theScore>0) {
                ScoreW=ScoreW+1;
                    ScoreD=ScoreD-1;
                }
            }else{
                if (theScore<0) {
                    ScoreW=ScoreW-1;
                    ScoreD=ScoreD+1;
                }
            }
        }
            break;
        case 1:{
            
            NSString *String= [[[self.arrayPicker objectAtIndex:alter] objectForKey:@"Shoot"] objectForKey:@"Name"];
            if ([String isEqualToString:@"乌龙"]) {
                if (theScore>0) {
                    ScoreD=ScoreD+1;
                    ScoreW=ScoreW-1;
                }
            }else{
                if (theScore<0) {
                    ScoreD=ScoreD-1;
                    ScoreW=ScoreW+1;
                }
            }
            
        }
            break;
        default:
            break;
    }
   }
-(void)DeleteScore:(NSInteger)index Score:(NSInteger)theScore{
    switch (index) {
        case 0:
        {
            NSString *String= [[[self.arrayTabel objectAtIndex:alter] objectForKey:@"Shoot"] objectForKey:@"Name"];
            if ([String isEqualToString:@"乌龙"]) {

                    //ScoreW=ScoreW+1;
                    ScoreD=ScoreD-1;
                
            }else{
                    ScoreW=ScoreW-1;
                    
                
            }
        }
            break;
        case 1:{
            
            NSString *String= [[[self.arrayPicker objectAtIndex:alter] objectForKey:@"Shoot"] objectForKey:@"Name"];
            if ([String isEqualToString:@"乌龙"]) {
                    //ScoreD=ScoreD+1;
                    ScoreW=ScoreW-1;
                
            }else{
                    ScoreD=ScoreD-1;
                   // ScoreW=ScoreW+1;
                
            }
            
        }
            break;
        default:
            break;
    }
}
@end
