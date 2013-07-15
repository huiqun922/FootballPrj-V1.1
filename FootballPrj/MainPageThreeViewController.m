//
//  MainPageThreeViewController.m
//  FootballPrj
//
//  Created by ytt on 12-12-28.
//  Copyright (c) 2012年 ytt. All rights reserved.
//

#import "MainPageThreeViewController.h"
#import "AddMemberView.h"
#import "TheMemberInfoView.h"
#import "FMDBServers.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ShareWithImage.h"
#import "MainPageAppDelegate.h"
@interface MainPageThreeViewController (){
    NSInteger theSection;
    BOOL ChangCi;
    BOOL JiuQiu;
    BOOL ZhuGong;
    BOOL showHeadView;
}

@property(nonatomic,retain)NSMutableArray *arrayInfo;  //球员位置排序得到的数组
@property(nonatomic,retain)NSMutableArray *arrayScore; //进球数得到的数组
@property(nonatomic,retain)NSMutableArray *arrayHeader; //有多少个位置
@end

@implementation MainPageThreeViewController
@synthesize arrayInfo,arrayScore;
@synthesize arrayHeader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
             self.title=@"成员管理";
        self.tabBarItem.image = [UIImage imageNamed:@"成员管理.png"];

        showHeadView=YES;
        
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
        
        UIButton *buttonMes=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonMes setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonMes setTitle:@"一键群发" forState:UIControlStateNormal];
        [buttonMes setFrame:CGRectMake(0, 0, 60.5, 30.0)];
        [buttonMes.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [buttonMes addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightMes=[[UIBarButtonItem alloc] initWithCustomView:buttonMes];
        
        self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:right,rightMes,nil];
        
        
        [left release];
        [right release];
        [rightMes release];
        //theSection=0;
    }
    return self;
}

-(void)getDateFromDB{
    self.arrayInfo=[NSMutableArray arrayWithCapacity:50];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
   self.arrayScore=[NSMutableArray arrayWithArray:[fmdbs getDateFromTable:0 Condition:nil] ];
    
    FMResultSet *fmrs=[fmdbs.dbs executeQuery:@"SELECT distinct weiZhi FROM User"];
  self.arrayHeader=[NSMutableArray arrayWithCapacity:50];
    while ([fmrs next]) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
        [dic setValue:[fmrs stringForColumn:@"weiZhi"] forKey:@"weiZhi"];
        [self.arrayHeader addObject:dic];
    }
    NSLog(@"arrayHeader :%@",self.arrayHeader);
    self.arrayHeader=[NSMutableArray arrayWithArray:[self ArrayPaiXu:self.arrayHeader]];
    NSLog(@"arrayHeader paiXu:%@",self.arrayHeader);

    theSection=[self.arrayHeader count];
    
    for (int i=0; i<[self.arrayHeader count]; i++) {
        NSMutableArray *array=[NSMutableArray arrayWithCapacity:50];
        FMResultSet *fmrsWeizhi=[fmdbs.dbs executeQuery:@"SELECT * FROM User where weiZhi = ?",[[self.arrayHeader objectAtIndex:i] objectForKey:@"weiZhi"]];
            while ([fmrsWeizhi next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
            [dic setValue:[fmrsWeizhi stringForColumn:@"Name"] forKey:@"Name"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"phoneNum"] forKey:@"phoneNum"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"QQ"] forKey:@"QQ"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"Number"] forKey:@"Number"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"weiZhi"] forKey:@"weiZhi"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"Jianjie"] forKey:@"Jianjie"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"ID"] forKey:@"ID"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"JinQiu"] forKey:@"JinQiu"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"ZhuGong"] forKey:@"ZhuGong"];
            [dic setValue:[fmrsWeizhi stringForColumn:@"ChangCi"] forKey:@"ChangCi"];
            [array addObject:dic];
        }
        
        [fmrsWeizhi close];
        [self.arrayInfo addObject:array];
    }
    
    [fmrs close];
    [fmdbs close];
    [fmdbs release];
//    NSLog(@"arrayScore : %@",self.arrayScore);
//    NSLog(@"arrayInfo : %@",self.arrayInfo);
//    NSLog(@"array : %@",self.arrayHeader);
}
//按照位置排序
-(NSArray *)ArrayPaiXu:(NSArray *)array{
    
    NSMutableArray *arrayP=[NSMutableArray arrayWithObjects:@"门将",@"后卫",@"中场",@"前锋",nil];
    NSMutableArray *arrayPX=[NSMutableArray arrayWithCapacity:50];
    for (int i=0; i<[arrayP count]; i++) {
        for(int j=0; j<[array count];j++) {
            if ([[arrayP objectAtIndex:i] isEqualToString:[[array objectAtIndex:j] objectForKey:@"weiZhi"]]){
                [arrayPX addObject:[NSDictionary dictionaryWithObject:[arrayP objectAtIndex:i] forKey:@"weiZhi"]];
                continue;
            }
        }
    }
    
    return arrayPX;
}

-(void)ComeBack:(id)sender{
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}
-(void)SendMessage:(id)sender{
    NSMutableArray *Array=[NSMutableArray arrayWithCapacity:50];
    for (int i=0; i<[self.arrayScore count]; i++) {
        [Array addObject:[[self.arrayScore objectAtIndex:i] objectForKey:@"phoneNum"]];
    }
    
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
	NSLog(@"can send SMS [%d]", canSendSMS);
	if (canSendSMS) {
        
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
		picker.messageComposeDelegate = self;
		picker.navigationBar.tintColor = [UIColor blackColor];
		picker.body = @"马上有比赛了，踊跃报名，积极参赛";
		picker.recipients = Array;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查短信功能是否正常" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
//短信功能发送委托
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
   // NSLog(@"MESSAGE RESULT %@",result);
    //[controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
            [controller dismissModalViewControllerAnimated:YES];
        }
            break;
        case MessageComposeResultFailed:// send failed{
        {
            NSLog(@"Message Failed");
        }
    
            break;
        case MessageComposeResultSent:
        {
            
            //do something
            NSLog(@"Message Sent");
            [controller dismissModalViewControllerAnimated:YES];

        }
            break;
        default:
            break;
    }
}
-(void)SelectTheMore:(id)sender{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:14];
    if(!view){
        
        [UIView beginAnimations:@"Move" context:NULL];// 動畫開始
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; // 動畫時間曲線
        [UIView setAnimationDuration:0.5];// 動畫時間
        [UIView commitAnimations];// 動畫結束
        [self settheshowView];
        
        
    }else{
        
        [UIView beginAnimations:@"Move" context:NULL];// 動畫開始
        [UIView setAnimationDuration:0.5f];// 動畫時間
        [UIView commitAnimations];// 動畫結束
        UIView *view1=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:14];
        [view1 removeFromSuperview];
    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    [self.theTableView setBackgroundColor:[UIColor clearColor]];
     [self.theTableView setSeparatorColor:[UIColor grayColor]];
    [self TheMoreInfo];

}
-(void)settheshowView{
    UIView *showView=[[UIView alloc] initWithFrame:CGRectMake(235.0,19.0, 81.5, 137.0)];
    [showView setBackgroundColor:[UIColor clearColor]];
    showView.layer.contents=(id)[UIImage imageNamed:@"下拉菜单.png"].CGImage;
    showView.tag=14;
    
    UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonright setBackgroundImage:[UIImage imageNamed:@"下拉按钮_2.png"] forState:UIControlStateNormal];
    [buttonright setFrame:CGRectMake(43,3, 36.5, 36.5)];
    [buttonright.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonright addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:buttonright];
    
    UIButton *buttonAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"添加" forState:UIControlStateNormal];
    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonAdd.titleLabel setTextColor:[UIColor yellowColor]];
    [buttonAdd addTarget:self action:@selector(AddTeam:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAdd setFrame:CGRectMake(10, 50, 61.5, 30)];
    [showView addSubview:buttonAdd];
    
    UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShare setBackgroundImage:[UIImage imageNamed:@"下拉菜单_button2.png"] forState:UIControlStateNormal];
    [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(ShareTeam:) forControlEvents:UIControlEventTouchUpInside];
    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];

    [buttonShare.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonShare setFrame:CGRectMake(10, 92, 61.5, 30)];
    [showView addSubview:buttonShare];
    [[UIApplication sharedApplication].keyWindow addSubview:showView];
    // [self.view addSubview:showView];
    [showView release];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self getDateFromDB];
    [self.theTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:14];
    [view removeFromSuperview];

    [super viewWillDisappear:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [arrayScore release];
    [arrayInfo release];
    [arrayHeader release];
    [_theNavBar release];
    [_theTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheNavBar:nil];
    [self setTheTableView:nil];
    [super viewDidUnload];
}

//tableview datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return theSection;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (showHeadView) {
    UIToolbar * topView = [[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(145, 0, 50, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    label.text=[[self.arrayHeader objectAtIndex:section] objectForKey:@"weiZhi"];
    [topView addSubview:label];
    [label release];
    return topView;
    }else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        int m=0;
    if (theSection==1) {
      
    return [self.arrayScore count];
    }
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if(![fmdbs OpenDatabase]){
        NSLog(@"Open Db fail");
    }
   // self.arrayInfo=[NSMutableArray arrayWithArray:[fmdbs getDateFromTable:0 Condition:nil] ];
    FMResultSet *fmrs=[fmdbs.dbs executeQuery:@"SELECT * FROM User where weiZhi = ?",[[self.arrayHeader objectAtIndex:section] objectForKey:@"weiZhi"]];
    while ([fmrs next]) {
      
        m++;
    }
    NSLog(@"mmm %d",m);
    [fmrs close];
    [fmdbs close];
    [fmdbs release];
    return m;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idString=@"idString";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell) {
     cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idString] autorelease];
        
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(8,3, 39, 39)];
        image.tag=6;
        [cell.contentView addSubview:image];
        [image release];
        
        //名字
        UILabel *labelName=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, 45)];
        labelName.tag=1;
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setTextColor:[UIColor whiteColor]];
        //[labelName setTextAlignment:UITextAlignmentCenter];
        labelName.numberOfLines=2;
        [labelName sizeThatFits:CGSizeMake(80, 45)];
        [cell.contentView addSubview:labelName];
        [labelName release];
       //位置
        UILabel *labelW=[[UILabel alloc] initWithFrame:CGRectMake(145, 0, 50, 45)];
        labelW.tag=2;
        [labelW setBackgroundColor:[UIColor clearColor]];
        [labelW setTextColor:[UIColor whiteColor]];
        //[labelW setTextAlignment:UITextAlignmentCenter];
        [cell.contentView addSubview:labelW];
        [labelW release];
       //出场次数
        UILabel *labelC=[[UILabel alloc] initWithFrame:CGRectMake(190, 0, 40, 45)];
        labelC.tag=3;
        [labelC setTextAlignment:UITextAlignmentCenter];
        [labelC setBackgroundColor:[UIColor clearColor]];
        [labelC setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:labelC];
        [labelC release];
        //进球
        UILabel *labelJ=[[UILabel alloc] initWithFrame:CGRectMake(230, 0, 40, 45)];
        labelJ.tag=4;
        [labelJ setTextAlignment:UITextAlignmentCenter];
        [labelJ setBackgroundColor:[UIColor clearColor]];
        [labelJ setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:labelJ];
        [labelJ release];
        //助攻
        UILabel *labelZ=[[UILabel alloc] initWithFrame:CGRectMake(270, 0, 40, 45)];
        labelZ.tag=5;
        [labelZ setTextAlignment:UITextAlignmentCenter];
        [labelZ setBackgroundColor:[UIColor clearColor]];
        [labelZ setTextColor:[UIColor whiteColor]];

        [cell.contentView addSubview:labelZ];
        [labelZ release];
    }
    NSArray *array=[NSArray array];
    if (theSection==1) {
        array=self.arrayScore;
    }else{
    array=[self.arrayInfo objectAtIndex:indexPath.section];
    }
    
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:6];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    
    // NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"touxiang%@.png",[[array objectAtIndex:indexPath.row] objectForKey:@"ID"]]];    
    [imageView setImage:[UIImage imageWithContentsOfFile:savedImagePath]];
    
    UILabel *labelName=(UILabel *)[cell.contentView viewWithTag:1];
    labelName.text=[[array objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    UILabel *labelW=(UILabel *)[cell.contentView viewWithTag:2];
    labelW.text=[[array objectAtIndex:indexPath.row] objectForKey:@"weiZhi"];
    
    UILabel *labelC=(UILabel *)[cell.contentView viewWithTag:3];
    labelC.text=[[array objectAtIndex:indexPath.row] objectForKey:@"ChangCi"];
    
    UILabel *labelJ=(UILabel *)[cell.contentView viewWithTag:4];
    labelJ.text=[[array objectAtIndex:indexPath.row] objectForKey:@"JinQiu"];
    
    UILabel *labelZ=(UILabel *)[cell.contentView viewWithTag:5];
    labelZ.text=[[array objectAtIndex:indexPath.row] objectForKey:@"ZhuGong"];

    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (showHeadView) {
        return 30.0f;
    }else return 0.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (theSection>1) {
      //  NSLog(@"%@",[self.arrayInfo objectAtIndex:indexPath.section]);
        
        
        TheMemberInfoView *memberInfo=[[TheMemberInfoView alloc] initWithNibName:@"TheMemberInfoView" bundle:nil TheInfo:[[self.arrayInfo objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        [memberInfo setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:memberInfo animated:YES];
        [memberInfo release];
        return;
    }
    TheMemberInfoView *memberInfo=[[TheMemberInfoView alloc] initWithNibName:@"TheMemberInfoView" bundle:nil TheInfo:[self.arrayScore objectAtIndex:indexPath.row]];
    [memberInfo setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:memberInfo animated:YES];
    [memberInfo release];
}
-(void)TheMoreInfo{
//    UIView *showView=[[UIView alloc] initWithFrame:CGRectMake(240, -120, 70, 0)];
//    [showView setBackgroundColor:[UIColor brownColor]];
//    showView.tag=10;
//    
//    UIButton *buttonAdd=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [buttonAdd setTitle:@"添加" forState:UIControlStateNormal];
//    [buttonAdd addTarget:self action:@selector(AddTeam:) forControlEvents:UIControlEventTouchUpInside];
//    [buttonAdd setFrame:CGRectMake(10, 10, 50, 30)];
//    [showView addSubview:buttonAdd];
//    
//    UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
//    [buttonShare addTarget:self action:@selector(ShareTeam:) forControlEvents:UIControlEventTouchUpInside];
//    [buttonShare setFrame:CGRectMake(10, 70, 50, 30)];
//    [showView addSubview:buttonShare];
//    
//    [self.view addSubview:showView];
//    [showView release];

}
-(void)AddTeam:(id)sender{
    AddMemberView *addmember=[[AddMemberView alloc] initWithNibName:@"AddMemberView" bundle:nil theInfo:nil];
    [addmember setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addmember animated:YES];
    [addmember release];
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:14];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];
}
-(void)ShareTeam:(id)sender{
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:14];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];
    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.shareView setTheContent:@"我的球员，蓄势待发。"];
    [app.shareView getImageFromView:self.view];
    [app.shareView simpleShareAllButtonClickHandler:self.tabBarController.view];
    
    
    
}
- (IBAction)SelectWeiZhi:(id)sender {
    showHeadView=YES;
    theSection=[self.arrayHeader count];
    [self.theTableView reloadData];
}

- (IBAction)SelectChangCi:(id)sender {
    showHeadView=NO;
    theSection=1;
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"ChangCi" ascending:ChangCi];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:&sorter count:1] autorelease];
    
    NSArray *sortedArray = [self.arrayScore sortedArrayUsingDescriptors:sortDescriptors];
    [sorter release];
    
    self.arrayScore= [NSMutableArray arrayWithArray: sortedArray ];
    //NSLog(@"%@",sortedArray);
    if (ChangCi) {
        ChangCi=NO;
    }else{
        ChangCi=YES;
    }
    [self.theTableView reloadData];
}

- (IBAction)SelectJinQiu:(id)sender {
    showHeadView=NO;
    theSection=1;
   // NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"JinQiu" ascending:JiuQiu];
   // NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:&sorter count:1] autorelease];
    
    NSArray *sortedArray = [self ScorePaiXu:self.arrayScore TheKeyValue:@"JinQiu" TheDesc:JiuQiu];
   // [sorter release];
    
    self.arrayScore= [NSMutableArray arrayWithArray: sortedArray ];
    //NSLog(@"%@",sortedArray);
    if (JiuQiu) {
        JiuQiu=NO;
    }else{
        JiuQiu=YES;
    }
    [self.theTableView reloadData];
}

- (IBAction)SelectZhuGong:(id)sender {
    showHeadView=NO;
    theSection=1;
   // NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"ZhuGong" ascending:ZhuGong];
   // NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:&sorter count:1] autorelease];
    
    NSArray *sortedArray = [self ScorePaiXu:self.arrayScore TheKeyValue:@"ZhuGong" TheDesc:ZhuGong];
   // [sorter release];
    
    self.arrayScore= [NSMutableArray arrayWithArray: sortedArray ];
    //NSLog(@"%@",sortedArray);
    if (ZhuGong) {
        ZhuGong=NO;
    }else{
        ZhuGong=YES;
    }
    [self.theTableView reloadData];
}

-(NSArray *)ScorePaiXu:(NSArray *)array TheKeyValue:(NSString *)keyValue  TheDesc:(BOOL)desc{
    
    
    NSComparisonResult *resultDesc;
    NSComparisonResult *resultAsc;
    if (desc) {
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
                 NSNumber *num1 = (NSNumber *)[dic1 objectForKey:keyValue];
                 NSNumber *num2 = (NSNumber *)[dic2 objectForKey:keyValue];
                 if ([num1 floatValue] == [num2 floatValue]) {
                     
                     NSNumber *numZ1 = (NSNumber *)[dic1 objectForKey:@"ChangCi"];
                     NSNumber *numZ2 = (NSNumber *)[dic2 objectForKey:@"ChangCi"];
                     if ([numZ1 floatValue] == [numZ2 floatValue]) {
                         NSInteger Jifen1=[[dic1 objectForKey:@"ZhuGong"] intValue]+[[dic1 objectForKey:@"JinQiu"] intValue]*2;
                        NSInteger Jifen2=[[dic2 objectForKey:@"ZhuGong"] intValue]+[[dic2 objectForKey:@"JinQiu"] intValue]*2;
                         if (Jifen1 < Jifen2)
                         {
                             return (NSComparisonResult)resultAsc;  //
                         }
                         else
                         {
                             return (NSComparisonResult)resultDesc;  //
                         }
                         
                     }else{
                         
                         NSInteger Cc1=[[dic1 objectForKey:@"ChangCi"] intValue];
                         NSInteger Cc2=[[dic2 objectForKey:@"ChangCi"] intValue];
                         if (Cc1 < Cc2)
                         {
                             return (NSComparisonResult)resultAsc;
                         }
                         else
                         {
                             return (NSComparisonResult)resultDesc;
                         }
                         
                     }
                     
                     
                 }
                 if ([num1 floatValue] < [num2 floatValue])
                 {
                     return (NSComparisonResult)resultAsc;
                 }
                 else
                 {
                     return (NSComparisonResult)resultDesc;
                 }
                 
                 return (NSComparisonResult)NSOrderedSame;
             }];
}
@end
