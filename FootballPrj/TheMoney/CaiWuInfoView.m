//
//  CaiWuInfoView.m
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "CaiWuInfoView.h"
#import "FMDBServers.h"
#import "FMResultSet.h"
#import "JSONKit.h"
#import "ActionSheetPicker.h"

@interface CaiWuInfoView (){
    BOOL isPersonal;
    NSInteger indexRow;
    float renjun;
    float yuE;
}
@property(nonatomic,retain)NSArray *array;
@property(nonatomic,retain)NSMutableArray *arrayDate;
@property(nonatomic,retain)NSMutableArray *arrayPicker;
@property(nonatomic,retain)UIDatePicker *theDatePicker;
@property(nonatomic,retain)UIPickerView *thePickerView;
@property(nonatomic,retain)NSDictionary *dicInfo;
@end

@implementation CaiWuInfoView
@synthesize array;
@synthesize arrayDate;
@synthesize theDatePicker;
@synthesize dicInfo;
@synthesize thePickerView;
@synthesize arrayPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"财务管理";
        // Custom initialization
        self.arrayDate=[NSMutableArray arrayWithObjects:@" ",@" ",@" ",nil];
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
        
        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"保存" forState:UIControlStateNormal];
        [buttonleft.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        [buttonleft addTarget:self action:@selector(SelectTheMore:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.rightBarButtonItem=right;
        [right release];
;
    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    if (isPersonal) {
//    UITableViewCell *cell=[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    UITextField *text=(UITextField *)[cell.contentView viewWithTag:12];
//    if (text) {
//            [self.arrayDate replaceObjectAtIndex:2 withObject:text.text];
//    }
    float handed=[[self.arrayDate objectAtIndex:2]floatValue]-[[dicInfo objectForKey:@"Money"] floatValue];
        if (handed==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"金额并未发生变化" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
    NSString *String=[[NSUserDefaults standardUserDefaults] objectForKey:@"TheTeamMoney"];
    float yue=[String floatValue]+handed;
       NSLog(@"yue :%f  %f",[String floatValue],handed);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)yue] forKey:@"TheTeamMoney"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
        int theID=[[dicInfo objectForKey:@"ID"]intValue];
        NSArray *arrar=[NSArray arrayWithObjects:[self.arrayDate objectAtIndex:2],[NSString stringWithFormat:@"%d",(int)handed], [self.arrayDate objectAtIndex:1],nil];
        if( [fmdbs UpdateDataWithIndex:5 UpdateData:arrar Condition:theID]){
          //  NSLog(@"SUCCESS  %@",text.text);
        }
        
    }
    [fmdbs close];
    [fmdbs release];
    }else{
        [self SavaTeamMoney];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)SavaTeamMoney{
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if ([fmdbs OpenDatabase]) {
        int theID=[[dicInfo objectForKey:@"BiSaiID"]intValue];
        NSArray *arrar=[NSArray arrayWithObjects:[self.arrayDate objectAtIndex:1], [self.arrayDate objectAtIndex:2],[self.arrayDate objectAtIndex:3],nil];
        //NSLog(@"UPDATE Array %@ \n %d",arrar,theID);
        if( [fmdbs UpdateDataWithIndex:4 UpdateData:arrar Condition:theID]){
            NSLog(@"SUCCESS  %d",theID);
        }
    }
    NSInteger count=0;
    FMResultSet *rsCount=[fmdbs.dbs executeQuery:@"select count(ID) as count From CaiWu"];
    if ([rsCount next]) {
        //NSLog(@"count : %@",[rsCount stringForColumn:@"count"]);
        count=[rsCount intForColumn:@"count"];
    }
    NSLog(@"%d",count);
    [rsCount close];
    NSArray *arrayJson=[[self.arrayDate objectAtIndex:2] objectFromJSONString];
    for (int i=0; i<[arrayJson count]; i++) {
    FMResultSet *rs=[fmdbs.dbs executeQuery:@"SELECT Money,ID FROM CaiWu where MemberID = ?",[arrayJson objectAtIndex:i]];
    if ([rs next]) {
        NSString *string=[rs stringForColumn:@"Money"];
        int theid=[rs intForColumn:@"ID"];
        float money=[string floatValue]+(renjun-[[self.arrayDate objectAtIndex:1] floatValue]);
        int theMoney=(int)money;
        NSLog(@"theMoney %d",theMoney);
        
        if([fmdbs.dbs  executeUpdate:@"UPDATE CaiWu set Money = ? where ID = ?",[NSString stringWithFormat:@"%d",theMoney],[NSNumber numberWithInt:theid]]){
            NSLog(@"SUCCESS %f %d",money,theid);
        }
    }
    [rs close];
    }
    [fmdbs close];
    [fmdbs release];
    
    //NSString *theMoney
    float chaju=[[[NSUserDefaults standardUserDefaults] objectForKey:@"TheTeamMoney"] floatValue]-yuE;
    NSString *theMoney=[NSString stringWithFormat:@"%d",(int)chaju];
    
    [[NSUserDefaults standardUserDefaults] setObject:theMoney forKey:@"TheTeamMoney"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    renjun=[[self.arrayDate objectAtIndex:1] floatValue];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 260) style:UITableViewStylePlain];
    self.theTableView=tableView;
    [tableView release];
    self.theTableView.delegate=self;
    self.theTableView.dataSource=self;
    self.theTableView.bounces=NO;
    [self.view addSubview:self.theTableView];
    
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;

    
}
-(void)setDefaultTableView:(NSDictionary *)Dic Personal:(BOOL)personal{
    isPersonal=personal;
    self.dicInfo=[NSDictionary dictionaryWithDictionary:Dic];
    if (!personal) {
        self.title=@"球队财务管理";
        self.array=[NSArray arrayWithObjects:@"时        间",@"人均消费", @"参加人数" ,@"经费余额", nil];
        self.arrayDate=[NSMutableArray arrayWithObjects:[Dic objectForKey:@"date"],[Dic objectForKey:@"renJunXiaoFei"],[Dic objectForKey:@"CanJiaRenShu"],[Dic objectForKey:@"yuE"], nil];
        renjun=[[Dic objectForKey:@"renJunXiaoFei"] floatValue];
        
        [self.theTableView reloadData];
    }else{
        self.title=@"个人财务管理";
            self.array=[NSArray arrayWithObjects:@"姓        名",@"缴纳时间" ,@"余        额", nil];
            [self.theTableView reloadData];
            
            self.arrayDate=[NSMutableArray arrayWithObjects:[Dic objectForKey:@"Name"],[Dic objectForKey:@"Date"],[Dic objectForKey:@"Money"], nil];
        if ([[Dic objectForKey:@"Date"] isEqualToString:@" "]||[Dic objectForKey:@"Date"==NULL]) {
            
            NSDateFormatter * formatter =[ [NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日"]; //dd 必须为小写 DD大写回产生错误。
            NSString* string = [formatter stringFromDate: [NSDate date]];
            [formatter release];
            
            [self.arrayDate replaceObjectAtIndex:1 withObject:string];
        }
        
        }


               NSLog(@"Dic ::  %@",Dic);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [array release];
    [arrayPicker release];
    [_theTableView release];
    [theDatePicker release];
    [thePickerView release];
    [super dealloc];
}
//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView setFrame:CGRectMake(10.0,10.0, 300, [self.array count]*45)];
    return [self.array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idString=@"idString";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idString] autorelease];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200.0f, 45.0f)];
        label.tag=1;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=UITextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label release];
    }
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:1];
    if([self.arrayDate count]>0)
    label.text=[self.arrayDate objectAtIndex:indexPath.row];
    cell.textLabel.text=[self.array objectAtIndex:indexPath.row];
    if (isPersonal) {
        switch (indexPath.row) {
            case 0:
            {
                FMDBServers *fmdbs=[[FMDBServers alloc] init];
                if ([fmdbs OpenDatabase]) {
                    NSString *ID=[self.dicInfo objectForKey:@"ID"];
                    
                    NSString *Name= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[ID intValue]]];
                    label.text=Name;
                    
                }
                [fmdbs close];
                [fmdbs release];
                
                
            }
                break;
            case 2:{
                label.text=[NSString stringWithFormat:@"%@ 元",[self.arrayDate objectAtIndex:indexPath.row] ];
                

            }
                
            default:{
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

            }
                break;
        }
        
    }else{
        if (indexPath.row==1) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            label.text=[NSString stringWithFormat:@"%@ 元",[self.arrayDate objectAtIndex:indexPath.row]];
            
        }else if(indexPath.row==2){
            NSArray *arrayJson=[[self.arrayDate objectAtIndex:indexPath.row] objectFromJSONString];
            label.text=[NSString stringWithFormat:@"%d",[arrayJson count]];

        }else if (indexPath.row==4){
            label.text=[NSString stringWithFormat:@"%@ 元",[self.arrayDate objectAtIndex:indexPath.row]];

        }
        
    }
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
   cell.selectionStyle=UITableViewCellSelectionStyleGray;
;
    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.arrayPicker=[NSMutableArray arrayWithCapacity:50];
    //[self.thePickerView reloadComponent:0];
    indexRow=indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            return;
        }
            break;
        case 1:{
      
                for (int i=1; i<1000; i++) {
                    [self.arrayPicker addObject:[NSString stringWithFormat:@"%d 元",i]];
                }
            
        }
            break;
        case 2:{
            if (isPersonal) {
                for (int i=1; i<1000; i++) {
                    [self.arrayPicker addObject:[NSString stringWithFormat:@"%d 元",i]];
                }
            }else{
                
                return;
            }
        }
            break;
        case 3:{
            return;
        }
            break;
        default:
            break;
    }
    if (isPersonal) {
    [self SetinputView:indexPath];
    }else{
    [self SetPersonalView:indexPath];
    }
    [self.thePickerView reloadComponent:0];
}

- (void)viewDidUnload {
    [self setTheTableView:nil];
    [super viewDidUnload];
}
-(void)SetinputView:(NSIndexPath *)indexPath{
    //self.indexpathNow=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
 
    
    
    if (indexPath.row==1&&isPersonal) {
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
        
        NSString *datastring=[NSString stringWithFormat:@"%@",[[NSArray arrayWithContentsOfFile:plistPath] objectAtIndex:1]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateStyle:kCFDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        if([datastring length]<10){
            
            [dateFormatter release];
            return;
        }
        NSDate *date1 = [dateFormatter dateFromString:datastring];
        
        ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.theTableView];
        [actionSheetPicker addCustomButtonWithTitle:@"当前时间" value:[NSDate date]];
        //    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
        
      //NSDate* minDate = [NSDate dateWithTimeIntervalSince1970:365*24*60*60];
        NSDate* maxDate =  [[NSDate date] dateByAddingTimeInterval:2 * 0];
        [actionSheetPicker SetDateWithMaxDate:maxDate MiniDate:date1];
        actionSheetPicker.hideCancel = YES;
        [actionSheetPicker showActionSheetPicker];
        //[actionSheetPicker release];
        
    }else{
//        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//            if ([self respondsToSelector:@selector(setText:)]) {
//                [self performSelector:@selector(setText:) withObject:selectedIndex];
//            }
//        };
//        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
//            NSLog(@"Block Picker Canceled");
//        };
//
//        [ActionSheetStringPicker showPickerWithTitle:@"" rows:self.arrayPicker initialSelection:0 doneBlock:done cancelBlock:cancel origin:self.theTableView];
        
        ActionSheetStringPicker *action=[[ActionSheetStringPicker alloc] initWithTitle:@"" rows:self.arrayPicker initialSelection:3 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            if ([self respondsToSelector:@selector(setText:)]) {
                [self performSelector:@selector(setText:) withObject:selectedIndex];
            }
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            NSLog(@"Block Picker Canceled");

        } origin:self.theTableView];
        
        [action addCustomButtonWithTitle:@"50" value:@"49"];
        [action addCustomButtonWithTitle:@"100" value:@"99"];
        [action addCustomButtonWithTitle:@"200" value:@"199"];
        [action showActionSheetPicker];
    }
    
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    
    NSDateFormatter * formatter =[ [NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"]; //dd 必须为小写 DD大写回产生错误。
    NSString *string = [formatter stringFromDate:selectedDate];
    [self.arrayDate replaceObjectAtIndex:1 withObject:string];
    [self.theTableView reloadData];
    [formatter release];
}
-(void)setText:(NSInteger)sender{

        
        //NSInteger selectRow=[self.thePickerView selectedRowInComponent:0];
        [self.arrayDate replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",sender+1]];
        
       // NSLog(@"floatValue :%f",[[NSString stringWithFormat:@"asd123asd"] floatValue]);
        
    [self.theTableView reloadData];
}


//编辑团队财务
-(void)SetPersonalView:(NSIndexPath *)indexPath{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([self respondsToSelector:@selector(setText:)]) {
            [self performSelector:@selector(setTeamMoney:) withObject:selectedIndex];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:self.arrayPicker initialSelection:0 doneBlock:done cancelBlock:cancel origin:self.theTableView];
    
}
-(void)setTeamMoney:(NSInteger)sender{
   // NSArray *arrayJson=[[self.arrayDate objectAtIndex:2] objectFromJSONString];

    NSString *LastRenJun=[NSString stringWithFormat:@"%@",[self.arrayDate objectAtIndex:1] ];
    [self.arrayDate replaceObjectAtIndex:indexRow withObject:[NSString stringWithFormat:@"%d",sender+1]];
    [self CalculateYue:LastRenJun];
    [self.theTableView reloadData];
}


-(void)CalculateYue:(NSString *)string{
    
    NSArray *arrayJson=[[self.arrayDate objectAtIndex:2] objectFromJSONString];
    float shangci=[string floatValue]*[arrayJson count];
    
    float Yue=[[self.arrayDate objectAtIndex:1] floatValue]*[arrayJson count]-shangci;
    yuE=Yue;
    float Thething=[[self.arrayDate objectAtIndex:3] floatValue]-Yue;
    NSLog(@"%f %f %f",shangci,Yue,Thething);
    
    [self.arrayDate replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",(int)Thething]];
    
}

@end
