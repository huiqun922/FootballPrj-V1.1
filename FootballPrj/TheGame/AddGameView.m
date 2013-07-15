//
//  AddGameView.m
//  FootballPrj
//
//  Created by mokbid on 13-5-13.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "AddGameView.h"
#import "EditViewController.h"
#import "FMDBServers.h"
#import "FMResultSet.h"
#import "ActionSheetPicker.h"

@interface AddGameView ()<EditDelegate>{
    NSArray *arrayPicker;
}
@property(nonatomic,retain)NSArray *array;
@property(nonatomic,retain)UIDatePicker *datePicker;
@property(nonatomic,retain)UIPickerView *thePickerView;
@property(nonatomic,retain)NSMutableArray *arraySelect;
@property(nonatomic,retain)NSIndexPath *indexPathNow;


@end

@implementation AddGameView
@synthesize array;
@synthesize datePicker;
@synthesize thePickerView;
@synthesize arraySelect,indexPathNow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"添加比赛";
        self.array=[NSArray arrayWithObjects:@"比赛日期",@"比赛时间",@"比赛地点",@"比赛对手" ,@"比赛阵型", nil];
        self.arraySelect=[NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ", nil];
        arrayPicker=[NSArray arrayWithObjects:@"3-3-1",@"3-2-2",@"4-2-1",@"2-3-2",@"2-2-3",@"4-4-2",@"4-3-3",@"4-5-1",@"3-5-2",@"3-4-3", nil];
        [arrayPicker retain];
        
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
        self.navigationItem.rightBarButtonItem=right;
        [right release];
    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    
    NSLog(@"array : %@",arraySelect);
    
    for(int i=0;i<[self.arraySelect count];i++) {
        if ([[self.arraySelect objectAtIndex:i] isEqualToString:@" "]||[[self.arraySelect objectAtIndex:i] isEqualToString:@""]||[self.arraySelect objectAtIndex:i]==NULL) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    
    NSMutableString *arraydata=[NSMutableString stringWithString:[self.arraySelect objectAtIndex:0]];
    NSMutableString *timeString=[self.arraySelect objectAtIndex:1];
    [arraydata insertString:timeString atIndex:10];
    [arraydata insertString:@" " atIndex:10];
   // NSLog(@"arrardate %@",arraydata);
    [self.arraySelect replaceObjectAtIndex:1 withObject:arraydata];
    [self.arraySelect removeObjectAtIndex:0];
            
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    if([fmdbs OpenDatabase]){
        
        FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT * FROM Bisai"];
        while ([rs next]) {
            
            if([[rs stringForColumn:@"Date"]isEqualToString:[self.arraySelect objectAtIndex:0]]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"同一时间不能添加两场比赛" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }

        }
        
        [rs close];
        
        if([fmdbs InsertDataWithIndex:1 InsertData:self.arraySelect]){
            NSLog(@"SUCCESS");
//            int age = [fmdbs.dbs intForQuery:@"SELECT MAX(ID) FROM Bisai WHERE"];
//                       NSLog(@"%d",age);
            FMResultSet *rs=[fmdbs.dbs executeQuery:@"SELECT ID FROM Bisai"];
            int theID=0;
            while ([rs next]) {
                theID=theID>[rs intForColumn:@"ID" ]?theID:[rs intForColumn:@"ID"];
            }
           NSArray *arrayW=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",theID],@" ", nil];
                [fmdbs InsertDataWithIndex:2 InsertData:arrayW];
        }
        
    }
    [fmdbs close];
    [fmdbs release];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    [self.theTableView setFrame:CGRectMake(10.0,10.0, 300.0, 225)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    [self setThePickerView:nil];
    [self setDatePicker:nil];
    [self setTheTableView:nil];
    [super viewDidUnload];
}
-(void)dealloc{
    [array release];
    [datePicker release];
    [thePickerView release];
    [_theTableView release];
    [super dealloc];
}
//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idStringGame=@"idStringGame";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idStringGame];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStringGame] autorelease];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(100.0f, 0.0f, 160.0f, 45.0f)];
        //label.backgroundColor=[UIColor brownColor];
        //label.text=[self.arraySelect objectAtIndex:indexPath.row];
        label.tag=19;
        label.textAlignment=UITextAlignmentCenter;
        label.textColor=[UIColor blackColor];
        [cell.contentView addSubview:label];
        [label release];
    }
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:19];
    label.text=[self.arraySelect objectAtIndex:indexPath.row];
   // NSLog(@"%@",[self.arraySelect objectAtIndex:indexPath.row]);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=[self.array objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    switch (indexPath.row) {
        case 0:{
            
            
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
            
            ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:tableView];
            [actionSheetPicker addCustomButtonWithTitle:@"当前时间" value:[NSDate date]];
            //    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
           // NSDate* minDate = [NSDate dateWithTimeIntervalSince1970:365*24*60*60];
            NSDate* maxDate =  [[NSDate date] dateByAddingTimeInterval:365*24*60*60];
            [actionSheetPicker SetDateWithMaxDate:maxDate MiniDate:date1];
            actionSheetPicker.hideCancel = YES;
            [actionSheetPicker showActionSheetPicker];
        }break;
        case 1:
        {
            ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(timeWasSelected:element:) origin:tableView];
            [actionSheetPicker addCustomButtonWithTitle:@"当前时间" value:[NSDate date]];
            //    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
            actionSheetPicker.hideCancel = YES;
            [actionSheetPicker showActionSheetPicker];
           // [actionSheetPicker release];
        }
            break;
            case 4:
        {
            ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                if ([self respondsToSelector:@selector(setText:)]) {
                    [self performSelector:@selector(setText:) withObject:selectedValue];
                }
            };
            ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
                NSLog(@"Block Picker Canceled");
            };
            NSArray *colors = [NSArray arrayWithObjects:@"3-3-1", @"3-2-2", @"4-2-1", @"2-2-3", @"4-4-2",@"4-3-3",@"4-5-1",@"3-5-2",@"3-4-3",nil];
            [ActionSheetStringPicker showPickerWithTitle:@"" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:tableView];
        }
            break;
        case 2:{
            EditViewController *edit=[[EditViewController alloc] initWithTitleIndex:indexPath.row Conten:[self.arraySelect objectAtIndex:indexPath.row] Length:50 KeyType:1];
            edit.editdelegate=self;
            edit.title=@"比赛地点";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
            
        }break;
        case 3:{
            EditViewController *edit=[[EditViewController alloc] initWithTitleIndex:indexPath.row Conten:[self.arraySelect objectAtIndex:indexPath.row] Length:10 KeyType:1];
            edit.editdelegate=self;
            edit.title=@"比赛对手";
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
            
        }break;
        default:{
        }
            break;
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    NSDateFormatter * formatter =[ [NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd EEEE"]; //dd 必须为小写 DD大写回产生错误。
    NSString* string = [formatter stringFromDate:selectedDate];
    [self.arraySelect replaceObjectAtIndex:0 withObject:string];
    [self.theTableView reloadData];
    [formatter release];
    
}
- (void)timeWasSelected:(NSDate *)selectedDate element:(id)element {
    NSDateFormatter * formatter =[ [NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm EEEE"]; //dd 必须为小写 DD大写回产生错误。
    [formatter setDateFormat:@"HH:mm"];
    NSString* string = [formatter stringFromDate:selectedDate];
    [self.arraySelect replaceObjectAtIndex:1 withObject:string];
    [self.theTableView reloadData];
    [formatter release];
    
}
-(void)setText:(id)sender{

    [self.arraySelect replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@",sender]];
    [self.theTableView reloadData];
}
//EditViewDelegate
-(void)EditData:(NSString *)theString Index:(NSInteger)index{
    
    [self.arraySelect replaceObjectAtIndex:index withObject:theString];
    [self.theTableView reloadData];
}
@end
