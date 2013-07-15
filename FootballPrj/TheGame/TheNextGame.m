//
//  TheNextGame.m
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "TheNextGame.h"
#import "FMDBServers.h"
#import "JSONKit.h"
#import "ActionSheetPicker.h"
#import "ShareWithImage.h"
#import "MainPageAppDelegate.h"

@interface TheNextGame (){
    int m;
    NSInteger buttontag;
}
@property(nonatomic,retain)UIPickerView *thePickerView;
@property(nonatomic,retain)NSMutableArray *arrayPicker;
@property(nonatomic,retain)NSMutableDictionary *dicMember;
@property(nonatomic,retain)NSMutableArray *arrayName;

@end

@implementation TheNextGame
@synthesize thePickerView;
@synthesize arrayPicker;
@synthesize dicMember;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"球员报名";
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
        [buttonright setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonright setTitle:@"完成" forState:UIControlStateNormal];
        [buttonright setFrame:CGRectMake(0, 0, 50.5, 30.5)];
        [buttonright.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonright addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonright];
        
        UIButton *buttonShare=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonShare setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
        [buttonShare setFrame:CGRectMake(0, 0, 50.5, 30.5)];
        [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonShare addTarget:self action:@selector(ShareWith:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *share=[[UIBarButtonItem alloc] initWithCustomView:buttonShare];
        
        self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:share,right, nil];
        [right release];
        [share release];
        self.dicMember=[NSMutableDictionary dictionaryWithCapacity:50];
        
        [self getDateFromDB];
    }
    return self;
}
-(void)SetID:(NSString *)stringID{
    
    m=[stringID intValue];
}
-(void)ShareWith:(id)sender{

    
    MainPageAppDelegate *app = (MainPageAppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.shareView setTheContent:@"面对比赛，我的球员斗志高昂，蓄势待发。"];
    [app.shareView getImageFromView:self.view];
    [app.shareView simpleShareAllButtonClickHandler:self.tabBarController.view];
    
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    
          NSString *JsonDic=[self.dicMember JSONString];
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
    if ([fmdbs.dbs  executeUpdate:@"UPDATE  CanSai set MemberID = ? where BisaiID = ?",JsonDic,[NSString stringWithFormat:@"%d",m]]) {
        NSLog(@"SUCCESS");
    }
        
    if ([fmdbs.dbs hadError]) {
        NSLog(@"Err %d: %@", [fmdbs.dbs lastErrorCode], [fmdbs.dbs lastErrorMessage]);
        //success = NO;
    }
    }
    [fmdbs close];
    [fmdbs release];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getDateFromDB{
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    self.arrayPicker=[NSMutableArray arrayWithArray:[fmdbs getDateFromTable:0 Condition:nil]];
    [fmdbs close];
    [fmdbs release];
    self.arrayName=[NSMutableArray arrayWithCapacity:50];
    
    for (int i=0; i<[self.arrayPicker count]; i++) {
        if ([[self.arrayPicker objectAtIndex:i] objectForKey:@"Name"]==nil) {
             [self.arrayName addObject:@""];
        }else{
        [self.arrayName addObject:[[self.arrayPicker objectAtIndex:i] objectForKey:@"Name"]];
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    //NSDictionary *DicTitle=[NSDictionary dictionary];
    if ([fmdbs OpenDatabase]) {
        //FMResultSet *rs=[fmdbs.dbs executeQuery:@"SELECT * FROM CanSai where BisaiID = ?"]
        NSString *buttontitle = [fmdbs.dbs stringForQuery:@"SELECT MemberID FROM CanSai WHERE BisaiID = ?",[NSString stringWithFormat:@"%d",m]];
        self.dicMember=[NSMutableDictionary dictionaryWithDictionary:[buttontitle objectFromJSONString]];
        
    }
    for (int i=1; i<=32; i++) {
        UIButton *button=(UIButton *)[self.view viewWithTag:i];
        
        NSString *stringID=[[self.dicMember objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"ID"];
       NSString *Name= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[stringID intValue]]];
        
               NSString *Number= [fmdbs.dbs stringForQuery:@"SELECT Number FROM USer WHERE ID = ?",[NSNumber numberWithInt:[stringID intValue]]];

        UILabel *labelNum=(UILabel *)[button viewWithTag:101];
        UILabel *labelName=(UILabel *)[button viewWithTag:102];
        
        
        //[MemButton setTitle:[self.arrayName objectAtIndex:[sender intValue]] forState:UIControlStateNormal];
        [labelNum setText:Number];
        [labelName setText:Name];
//        NSLog(@"%d   %@",i,[[self.dicMember objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"Name"]);
    }
  //  NSLog(@"%@",dicMember);
    [fmdbs close];
    [fmdbs release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    CGFloat i5gaodu=0;
    if (iPhone5) {
        i5gaodu=88;
    }
    
    [self ZhenXingPanlie];
    
    [self.theLabel setFrame:CGRectMake(0, 367+i5gaodu, 51, 49)];
    [self.theDeleteButton setFrame:CGRectMake(225, 312+i5gaodu, 85, 44)];
    [self.theScrollView setFrame:CGRectMake(51, 367+i5gaodu, 269, 49)];
    self.theScrollView.showsHorizontalScrollIndicator=NO;
    for (int i=0; i<20; i++) {
//        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:[UIImage imageNamed:@"足球场地图_球衣.png"] forState:UIControlStateNormal];
//        button.tag=12+i;
//        [button addTarget:self action:@selector(SelectMember:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
//        [button setFrame:CGRectMake(1.4+(65+1.4)*i, 2, 65, 48)];
        UIButton *button=[self getButton:12+i TheRect:CGRectMake(1.4+(65+1.4)*i, 2, 65, 48)];
        [self.theScrollView addSubview:button];
    }
   UIImage*img =[UIImage imageNamed:@"候补区底图.png"];
   UIImageView *houbu=[[UIImageView alloc] initWithImage:img];
    [houbu setFrame:CGRectMake(0.0, 367.0+i5gaodu, 320, 49)];
    [self.view addSubview:houbu];
    [self.theScrollView setContentSize:CGSizeMake(267*5, 49)];
    [self.theScrollView setPagingEnabled:YES];
    
    
    UIImageView *imageView=[[UIImageView  alloc] initWithFrame:CGRectMake(26.25, 7.5, 267.5, 355.5 + i5gaodu)];
    [imageView setImage:[UIImage imageNamed:@"足球场地图.png"]];
    [self.view insertSubview:imageView atIndex:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    [self setThePickerView:nil];
    [self setTheScrollView:nil];
    [self setTheDeleteButton:nil];
    [self setTheLabel:nil];
    [super viewDidUnload];
}
-(void)dealloc{
    [thePickerView release];
    [arrayPicker release];
    [_theScrollView release];
    [dicMember release];
    [_theDeleteButton release];
    [_theLabel release];
    [super dealloc];
}
- (IBAction)DeleteGame:(UIButton *)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消本场比赛？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
    
}
//UIAlertView 委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        FMDBServers *fmdbs=[[FMDBServers alloc] init];
        if ([fmdbs OpenDatabase]) {
            if([fmdbs.dbs executeUpdate:@"delete from BiSai where ID = ?",[NSNumber numberWithInteger:m]]&&[fmdbs.dbs executeUpdate:@"delete from CanSai where BisaiID = ?",[NSNumber numberWithInteger:m]]){
                NSLog(@"Delete Success");
            }
            
        }
        [fmdbs close];
        [fmdbs release];
        [self.navigationController popViewControllerAnimated:YES];

        
    }else{
        NSLog(@"cacnle");
    }
}

- (IBAction)SelectMember:(UIButton *)sender{
    buttontag=sender.tag;

    if ([arrayPicker count]<1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先添加球员" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([self respondsToSelector:@selector(setText:)]) {
            [self performSelector:@selector(setText:) withObject:[NSNumber numberWithInteger:selectedIndex]];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
   // NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];
    [ActionSheetStringPicker showPickerWithTitle:@"选择球员" rows:self.arrayName initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    

}
-(void)setText:(NSNumber *)sender{
    
   // NSLog(@"%@",[self.arrayName objectAtIndex:[sender intValue]]);
    
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
     
    for (int i=1; i<=32; i++) {
       // UIButton *button=(UIButton *)[self.view viewWithTag:i];
        
        NSString *stringID=[[self.dicMember objectForKey:[NSString stringWithFormat:@"%d",i]]objectForKey:@"ID"];
        NSString *Name= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[stringID intValue]]];
       // NSLog(@"Name: %@",Name);
        if ([Name isEqualToString:[self.arrayName objectAtIndex:[sender intValue]]]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该球员已经报名，请勿重复报名" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [fmdbs close];
            [fmdbs release];
            return ;
            
        }

    }
    }
  
    [fmdbs close];
    [fmdbs release];
    
    UIButton *MemButton=(UIButton *)[self.view viewWithTag:buttontag];
    UILabel *labelNum=(UILabel *)[MemButton viewWithTag:101];
    UILabel *labelName=(UILabel *)[MemButton viewWithTag:102];

    
    //[MemButton setTitle:[self.arrayName objectAtIndex:[sender intValue]] forState:UIControlStateNormal];
    [labelNum setText:[[self.arrayPicker objectAtIndex:[sender intValue]] objectForKey:@"Number"]];
    [labelName setText:[self.arrayName objectAtIndex:[sender intValue]]];
    
    [self.dicMember setObject:[self.arrayPicker objectAtIndex:[sender intValue]] forKey:[NSString stringWithFormat:@"%d",buttontag]];
}

-(void)ZhenXingPanlie{
    NSString *zhenxing=nil;
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
      zhenxing=[fmdbs.dbs stringForQuery:@"SELECT Zhenxing FROM Bisai WHERE ID = ?",[NSNumber numberWithInt:m]];
        NSLog(@"ZhenXing :%@",zhenxing);
    }
    [fmdbs close];
    [fmdbs release];
    
    NSInteger row1=[[zhenxing substringWithRange:NSMakeRange(0, 1)] integerValue];
    NSInteger row2=[[zhenxing substringWithRange:NSMakeRange(2, 1)] integerValue];
    NSInteger row3=[[zhenxing substringWithRange:NSMakeRange(4, 1)] integerValue];

    NSLog(@"zhenxing : %d %d %d",row1,row2,row3);
    CGFloat rowW1=(267.5-row3*65)/(row3+1);
    CGFloat rowW2=(267.5-row2*65)/(row2+1);
    CGFloat rowW3=(267.5-row1*65)/(row1+1);
    
    CGFloat i5gaodu=0;
    if (iPhone5) {
        i5gaodu=88;
    }
    

    
    for (int i=1; i<=row3; i++) {
        
       UIButton *button=[self getButton:i TheRect:CGRectMake(26.25 + rowW1 +(rowW1 + 65)*(i-1), 20, 65, 48)];
        [self.view addSubview:button];
    }
    
    for (int i=1; i<=row2; i++) {
        
        UIButton *button=[self getButton:i+row3 TheRect:CGRectMake(26.25 + rowW2 +(rowW2 + 65)*(i-1), 100+(i5gaodu/4), 65, 48)];
        [self.view addSubview:button];

    }
    for (int i=1; i<=row1; i++) {
        
        UIButton *button=[self getButton:i+row3+row2 TheRect:CGRectMake(26.25 + rowW3 +(rowW3 + 65)*(i-1), 220+(i5gaodu/1.2), 65, 48)];
        [self.view addSubview:button];
    }
    
    
    UIButton *button=[self getButton:11 TheRect:CGRectMake(127.5,305+i5gaodu,65,48)];
    [self.view addSubview:button];

}
-(UIButton *)getButton:(NSInteger)theTag TheRect:(CGRect)rect{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"足球场地图_球衣.png"] forState:UIControlStateNormal];
    button.tag=theTag;
    [button addTarget:self action:@selector(SelectMember:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [button setFrame:rect];
    UILabel *labelNum=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 65, 20)];
    [labelNum setFont:[UIFont systemFontOfSize:11.0]];
    [labelNum setBackgroundColor:[UIColor clearColor]];
    [labelNum setTextAlignment:UITextAlignmentCenter];
    //labelNum.text=@"15";
    labelNum.tag=101;
    [button addSubview:labelNum];
    
    UILabel *labelName=[[UILabel alloc] initWithFrame:CGRectMake(0, 25, 65, 20)];
    [labelName setFont:[UIFont systemFontOfSize:11.0]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setTextAlignment:UITextAlignmentCenter];
    labelName.tag=102;
    //labelName.text=@"周到你";
    [button addSubview:labelName];
    
    //[self.view addSubview:button];
    
    return button;
}
@end
