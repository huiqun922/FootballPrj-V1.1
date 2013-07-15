//
//  TheMemberInfoView.m
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "TheMemberInfoView.h"
#import "AddMemberView.h"
#import "ShareWithImage.h"
#import "FMDBServers.h"
#import "MainPageAppDelegate.h"

@interface TheMemberInfoView ()
@property(nonatomic,strong)NSDictionary *dicInfo;
@property(nonatomic,copy)NSString *ShareStringl;

@end

@implementation TheMemberInfoView
@synthesize theImageView;
@synthesize dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil TheInfo:(NSDictionary *)dic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIButton *buttonback=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonback setBackgroundImage:[UIImage imageNamed:@"返回_2.png"] forState:UIControlStateNormal];
        [buttonback setTitle:@"  返回" forState:UIControlStateNormal];
        [buttonback setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonback.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonback addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:buttonback];
        self.navigationItem.leftBarButtonItem =back;
        self.navigationItem.hidesBackButton = YES;
        [back release];
        
        UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonright setBackgroundImage:[UIImage imageNamed:@"下拉按钮_2.png"] forState:UIControlStateNormal];
        [buttonright setFrame:CGRectMake(0, 0, 36.5, 36.5)];
        [buttonright.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonright addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonright];
        self.navigationItem.rightBarButtonItem=right;
        [right release];
        
        self.dicInfo=[NSDictionary dictionaryWithDictionary:dic];

    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:15];
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
        UIView *view1=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:15];
        [view1 removeFromSuperview];
    }}
-(void)SetTheUI:(NSDictionary *)dic{
    NSMutableDictionary *dicc=[NSMutableDictionary dictionaryWithCapacity:50];
    int theID=[[self.dicInfo objectForKey:@"ID"] intValue];

    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
        FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT * FROM User where ID = ?",[NSNumber numberWithInt:theID]];
        if ([rs next]) {
            NSLog(@"%@",[rs stringForColumn:@"ID"]);
           // NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
            [dicc setValue:[rs stringForColumn:@"name"] forKey:@"Name"];
            [dicc setValue:[rs stringForColumn:@"phoneNum"] forKey:@"phoneNum"];
            [dicc setValue:[rs stringForColumn:@"QQ"] forKey:@"QQ"];
            [dicc setValue:[rs stringForColumn:@"Number"] forKey:@"Number"];
            [dicc setValue:[rs stringForColumn:@"weiZhi"] forKey:@"weiZhi"];
            [dicc setValue:[rs stringForColumn:@"Jianjie"] forKey:@"Jianjie"];
            [dicc setValue:[rs stringForColumn:@"ID"] forKey:@"ID"];
            [dicc setValue:[rs stringForColumn:@"JinQiu"] forKey:@"JinQiu"];
            [dicc setValue:[rs stringForColumn:@"ZhuGong"] forKey:@"ZhuGong"];
            [dicc setValue:[rs stringForColumn:@"ChangCi"] forKey:@"ChangCi"];
            //[array addObject:dic];
        }
        
        [rs close];
    }
    [fmdbs close];
    [fmdbs release];
    
    self.title=[dicc objectForKey:@"Name"];
    self.ShareStringl=[NSString stringWithFormat:@"%@,%@",[dicc objectForKey:@"weiZhi"],[dicc objectForKey:@"Name"]];
    self.theTextView.text=[dicc objectForKey:@"Jianjie"];
    self.labelW.text=[NSString stringWithFormat:@"号码 : %@     位置 : %@",[dicc objectForKey:@"Number"],[dicc objectForKey:@"weiZhi"]];
    self.labelPhone.text=[NSString stringWithFormat:@"电话 : %@",[dicc objectForKey:@"phoneNum"] ];
    self.labelQQ.text=[NSString stringWithFormat:@"QQ : %@",[dicc objectForKey:@"QQ"] ];
    self.LabelCC.text=[dicc objectForKey:@"ChangCi"];
    [self GetMemberMoney:[dicc objectForKey:@"ID"]];
    self.labelJQ.text=[dicc objectForKey:@"JinQiu"];
    self.labelZG.text=[dicc objectForKey:@"ZhuGong"];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
      
    // NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"touxiang%@.png",[dic objectForKey:@"ID"]]];
    //UIImage *image=[UIImage imageWithContentsOfFile:savedImagePath];

    [self.theImageView setImage:[UIImage imageWithContentsOfFile:savedImagePath]];
}
-(void)viewWillAppear:(BOOL)animated{

    [self SetTheUI:dicInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.theTextView.text=@"ewgkjbwguiwiugbwiugbwibiby";
//    self.labelJE.text=@"0000";
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    [self.theTextView setBackgroundColor:[UIColor clearColor]];
    [self.theTextView setTextColor:[UIColor whiteColor]];
    
    self.theImageView=[[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)] autorelease];
    [self.theImageView setImage:[UIImage imageNamed:@"morentou.png"]];
    self.theImageView.layer.masksToBounds=YES;
    self.theImageView.layer.cornerRadius=5.5;
    [self.view addSubview:self.theImageView];
    self.theTextImage.layer.masksToBounds=YES;
    self.theTextImage.layer.cornerRadius=2.2;
    
    if (iPhone5) {
        [self.deleteButton setFrame:CGRectMake(211, 365+78, 85, 44)];
        [self.thedataimage setFrame:CGRectMake(10.0, 255.0+68, 300.0, 106)];
        [self.label11 setFrame:CGRectMake(35, 268+68, 34, 21)];
        [self.label12 setFrame:CGRectMake(106, 268+68, 34, 21)];
        [self.label13 setFrame:CGRectMake(175, 268+68, 34, 21)];
        [self.label14 setFrame:CGRectMake(254, 268+68, 34, 21)];
        
        [self.LabelCC setFrame:CGRectMake(35, 315+68, 34, 21)];
        [self.labelJQ setFrame:CGRectMake(106, 315+68, 34, 21)];
        [self.labelZG setFrame:CGRectMake(175, 315+68, 34, 21)];
        [self.labelJE setFrame:CGRectMake(254, 315+68, 34, 21)];
        
        [self.theTextImage setFrame:CGRectMake(10, 150, 300, 152)];
        [self.theTextView setFrame:CGRectMake(10, 150, 300, 152)];
        
        [self.fengexian setFrame:CGRectMake(0, 140, 320, 10)];
        
        [self.theImageView setFrame:CGRectMake(20, 20, 100, 100)];
        
        [self.labelPhone setFrame:CGRectMake(136, 95, 156, 21)];
        [self.labelQQ setFrame:CGRectMake(136, 60, 156, 21)];
        [self.labelW setFrame:CGRectMake(136, 25, 206,21)];
        
        
        
    }

    

}
-(void)settheshowView{
    UIView *showView=[[UIView alloc] initWithFrame:CGRectMake(235.0,19.0, 81.5, 137.0)];
    [showView setBackgroundColor:[UIColor clearColor]];
    showView.layer.contents=(id)[UIImage imageNamed:@"下拉菜单.png"].CGImage;
    showView.tag=15;
    
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
    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonShare.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonShare setFrame:CGRectMake(10, 92, 61.5, 30)];
    [showView addSubview:buttonShare];
    [[UIApplication sharedApplication].keyWindow addSubview:showView];
    // [self.view addSubview:showView];
    [showView release];
    
}
-(void)AddTeam:(id)sender{
     AddMemberView *addteamView=[[AddMemberView alloc] initWithNibName:@"AddMemberView" bundle:nil theInfo:self.dicInfo];
    [self.navigationController pushViewController:addteamView animated:YES];
    [addteamView release];
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:15];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];
    
}
-(void)ShareTeam:(id)sender{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:15];
    [view removeFromSuperview];
    UIView *showview=(UIView *)[self.navigationItem.titleView viewWithTag:10];
    [showview setHidden:YES];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
    
    NSString *TeamName=[NSString stringWithFormat:@"%@",[[NSArray arrayWithContentsOfFile:plistPath] objectAtIndex:0]];
    
    
    
    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.shareView setTheContent:[NSString stringWithFormat:@"这员大将便是传说中我们 %@ 球队的 %@ 。",TeamName, self.ShareStringl]];
    [app.shareView getImageFromView:self.view];
    [app.shareView simpleShareAllButtonClickHandler:self.tabBarController.view];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//UItextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:15];
    [view removeFromSuperview];
    [super viewWillDisappear:NO];
}
- (void)dealloc {
    [_theTextView release];
    [theImageView release];
    [_labelW release];
    [_labelQQ release];
    [_labelPhone release];
    [_LabelCC release];
    [_labelJQ release];
    [_labelZG release];
    [_labelJE release];
    [dicInfo release];
    [_theTextImage release];
    [_thedataimage release];
    [_label11 release];
    [_label12 release];
    [_label13 release];
    [_label14 release];
    [_deleteButton release];
    [_fengexian release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheTextView:nil];
    [self setTheImageView:nil];
    [self setLabelW:nil];
    [self setLabelQQ:nil];
    [self setLabelPhone:nil];
    [self setLabelCC:nil];
    [self setLabelJQ:nil];
    [self setLabelZG:nil];
    [self setLabelJE:nil];
    [self setTheTextImage:nil];
    [self setThedataimage:nil];
    [self setLabel11:nil];
    [self setLabel12:nil];
    [self setLabel13:nil];
    [self setLabel14:nil];
    [self setDeleteButton:nil];
    [self setFengexian:nil];
    [super viewDidUnload];
}
-(void)GetMemberMoney:(NSString *)stringmoney{
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
        FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT * FROM CaiWu where MemberID = ?",stringmoney];
        if ([rs next]) {
            //NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:50];
            self.labelJE.text=[rs stringForColumn:@"Money"];
  
            //[array addObject:dic];
        }
        
        [rs close];
        
    }
    [fmdbs close];
    [fmdbs release];
}
- (IBAction)DeleteMember:(UIButton *)sender {
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:15];
    [view removeFromSuperview];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该球员?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}
//UIAlertView 委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        int theID=[[self.dicInfo objectForKey:@"ID"] intValue];
        NSLog(@"theID :%d",theID);
        FMDBServers *fmdbs=[[FMDBServers alloc] init];
        if([fmdbs OpenDatabase]){
            if([fmdbs.dbs executeUpdate:@"delete from User where ID = ?",[NSNumber numberWithInteger:theID]]){
                NSLog(@"delete Success");
            }
            [fmdbs.dbs executeUpdate:@"delete from CaiWu where MemberID = ?",[NSString stringWithFormat:@"%d",theID]];
        }
        [fmdbs close];
        [fmdbs release];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSLog(@"cacnle");
    }
}

@end
