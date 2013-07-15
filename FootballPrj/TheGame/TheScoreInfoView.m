//
//  TheScoreInfoView.m
//  FootballPrj
//
//  Created by mokbid on 13-5-14.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "TheScoreInfoView.h"
#import "FMDBServers.h"
#import "ActionSheetPicker.h"

@interface TheScoreInfoView (){
    NSInteger theIndex;
    NSInteger theScore;
    BOOL WuLong;
}
@property(nonatomic,retain)UIPickerView *thePickerView;
@property(nonatomic,retain)NSMutableArray *arrayPicker;
@property(nonatomic,retain)NSIndexPath *indexPathNow;
@property(nonatomic,retain)NSMutableArray *arrayID;
@property(nonatomic,retain)NSMutableArray *arrayAction;


@end

@implementation TheScoreInfoView
@synthesize thePickerView;
@synthesize arrayPicker,arrayTabel;
@synthesize indexPathNow;
@synthesize arrayID;
@synthesize TheDelegate;
@synthesize Add;
@synthesize arrayAction;

- (IBAction)DeleteScore:(UIButton *)sender {
    
    [self.TheDelegate DeleteJinQiu:self.arrayTabel Index:theIndex Score:theScore];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Index:(NSInteger)index
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        theIndex=index;
        Add=YES;
        self.title=@"进球详情";
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

        theScore=1;
        self.arrayAction=[NSMutableArray arrayWithCapacity:100];
        self.arrayID=[NSMutableArray arrayWithObjects:@" ",@" ",@" ", nil];
        self.arrayTabel=[NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"0" forKey:@"Name"],[NSDictionary dictionaryWithObject:@"其他球员" forKey:@"Name"],[NSDictionary dictionaryWithObject:@"其他球员" forKey:@"Name"], nil];

    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SelectTheMore:(id)sender{
    if (Add) {
    [self.TheDelegate TheDicInfo:self.arrayTabel Index:theIndex Score:theScore TheIDArray:arrayID];

    }else{
        [self.TheDelegate UpdateJinQiu:self.arrayTabel Index:theIndex Score:theScore];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)getMember{
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
   NSMutableArray *array=[NSMutableArray arrayWithArray:[fmdbs getDateFromTable:0 Condition:nil]];
    [fmdbs close];
    [fmdbs release];
    return array;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
    if (Add) {
        self.DeleteButton.hidden=YES;

    }
    if (theIndex==0) {
    [self.theTableView setFrame:CGRectMake(10, 10, 300, 45*3)];
    }else{
        [self.theTableView setFrame:CGRectMake(10, 10, 300, 45*2)];
   
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (theIndex==0) {
    return 3;
    }else{
        return 2;
    }
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
    NSArray *array=[NSArray arrayWithObjects:@"进球时间",@"进球队员",@"助攻队员", nil];
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:19];
   // label.text=[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Name"];
    if (indexPath.row==0) {
        label.text=[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Name"];

    }else{
        NSString *stringID=[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"ID"];

        if([stringID isEqualToString:@" "]||[stringID isEqualToString:@"其他球员"]){
            label.text=[[self.arrayTabel objectAtIndex:indexPath.row] objectForKey:@"Name"];
            
        }else{
        FMDBServers *fmdbs=[[FMDBServers alloc] init];
            if ([fmdbs OpenDatabase]) {
           // NSLog(@"ID :%@",stringID);
            NSString *Name= [fmdbs.dbs stringForQuery:@"SELECT name FROM USer WHERE ID = ?",[NSNumber numberWithInt:[stringID intValue]]];
            label.text=Name;
        }
        [fmdbs close];
        [fmdbs release];
    }
    }
    // NSLog(@"%@",[self.arraySelect objectAtIndex:indexPath.row]);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      self.arrayPicker=[NSMutableArray arrayWithCapacity:50];
    switch (indexPath.row) {
        case 0:
        {
           // self.arrayPicker=[NSMutableArray arrayWithCapacity:100];
            for (int i=1; i<121; i++) {
                NSDictionary *dic=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",i] forKey:@"Name"];
                [self.arrayPicker addObject:dic];
            }
            [self.arrayPicker addObject:[NSDictionary dictionaryWithObject:@"点球" forKey:@"Name"]];
        }
            break;
        case 1:{
            

            if (theIndex==0) {
                self.arrayPicker=[self getMember];
            }
            
            NSMutableDictionary *dicWuLong=[NSMutableDictionary dictionaryWithCapacity:2];
            [dicWuLong setObject:@"乌龙" forKey:@"Name"];
            [dicWuLong setObject:@" " forKey:@"ID"];
            [self.arrayPicker addObject:dicWuLong];
            NSMutableDictionary *dicSome=[NSMutableDictionary dictionaryWithCapacity:2];
            [dicSome setObject:@"其他球员" forKey:@"Name"];
            [dicSome setObject:@" " forKey:@"ID"];
            [self.arrayPicker insertObject:dicSome atIndex:0];
            
        }break;
        case 2:{
            if([[[self.arrayTabel objectAtIndex:1] objectForKey:@"Name"] isEqualToString:@"乌龙"]||[[[self.arrayTabel objectAtIndex:1] objectForKey:@"Name"]isEqualToString:@"点球"]){
                
                NSMutableDictionary *dicSome=[NSMutableDictionary dictionaryWithCapacity:2];
                [dicSome setObject:@"无" forKey:@"Name"];
                [dicSome setObject:@" " forKey:@"ID"];
                [self.arrayPicker insertObject:dicSome atIndex:0];
                break;
            }
            self.arrayPicker=[NSMutableArray arrayWithCapacity:50];
            if (theIndex==0) {
            self.arrayPicker=[self getMember];
            }
            
//            NSMutableDictionary *dicWuLong=[NSMutableDictionary dictionaryWithCapacity:2];
//            [dicWuLong setObject:@"乌龙" forKey:@"Name"];
//            [dicWuLong setObject:@" " forKey:@"ID"];
//            [self.arrayPicker addObject:dicWuLong];
            NSMutableDictionary *dicSome=[NSMutableDictionary dictionaryWithCapacity:2];
            [dicSome setObject:@"其他球员" forKey:@"Name"];
            [dicSome setObject:@" " forKey:@"ID"];
            [self.arrayPicker insertObject:dicSome atIndex:0];
        }
            break;
    }
    [self.thePickerView reloadComponent:0];
    [self SetinputView:indexPath];
}
//UIPickerView DataSoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrayPicker count];
}
//UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([[arrayPicker objectAtIndex:row] isKindOfClass:[NSString class]]) {
          return [arrayPicker objectAtIndex:row];;
    }
    return [[arrayPicker objectAtIndex:row] objectForKey:@"Name"];
}

-(void)SetinputView:(NSIndexPath *)indexPath{
    
    self.indexPathNow=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    self.arrayAction=[NSMutableArray arrayWithCapacity:100];
    for (int i=0; i<[self.arrayPicker count]; i++) {
        [self.arrayAction addObject:[[self.arrayPicker objectAtIndex:i] objectForKey:@"Name"]];
    }
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([self respondsToSelector:@selector(setText:)]) {
            [self performSelector:@selector(setText:) withObject:selectedIndex];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };

    
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:self.arrayAction initialSelection:0 doneBlock:done cancelBlock:cancel origin:self.theTableView];
}

-(void)setText:(NSInteger)index{
    NSMutableArray *arraywulong=[NSMutableArray arrayWithCapacity:100];
    
    if(self.indexPathNow.row==1){
        if ((index+1)==[self.arrayPicker count]) {
            theScore=-1;
            WuLong=YES;
            
           // self.arrayPicker=[NSMutableArray arrayWithCapacity:100];
            NSMutableDictionary *dicSome=[NSMutableDictionary dictionaryWithCapacity:2];
            [dicSome setObject:@"无" forKey:@"Name"];
            [dicSome setObject:@" " forKey:@"ID"];
            [arraywulong insertObject:dicSome atIndex:0];
            
            [self.arrayTabel replaceObjectAtIndex:2 withObject:[arraywulong objectAtIndex:0]];
            [self.arrayID replaceObjectAtIndex:2 withObject:[arraywulong objectAtIndex:0 ]];
            
        }else{
            WuLong=NO;
            theScore=1;
        }
        
    }
    //NSLog(@"theScore : %d",theScore);
    
    if ([[arrayPicker objectAtIndex:index] isKindOfClass:[NSString class]]) {
        [self.arrayTabel replaceObjectAtIndex:indexPathNow.row withObject:[arrayPicker objectAtIndex:index]];
    }else{
        //判断进球跟助攻是不是同一个人
        
        if ([self iSSameBody:[[arrayPicker objectAtIndex:index] objectForKey:@"Name"] Index:indexPathNow.row]) {
            
        
        [self.arrayTabel replaceObjectAtIndex:indexPathNow.row withObject:[arrayPicker objectAtIndex:index]];
        [self.arrayID replaceObjectAtIndex:indexPathNow.row withObject:[arrayPicker objectAtIndex:index]];
        }
    }
    [self.theTableView reloadData];
}

-(BOOL)iSSameBody:(NSString *)string Index:(NSInteger)index{
    NSLog(@"The Name %@",string);
    
    if ([string isEqualToString:@"其他球员"]) {
        return YES;
    }
    
    switch (index) {
        case 1:
        {
            if ([string isEqualToString:[[self.arrayTabel objectAtIndex:2]objectForKey:@"Name"]]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"进球跟助攻不能为同一人" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return NO;
            }
        }
            break;
        case 2:{
            if ([string isEqualToString:[[self.arrayTabel objectAtIndex:1]objectForKey:@"Name"]]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"进球跟助攻不能为同一人" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return NO;
            }
        }break;
        default:
            break;
    }
    return YES;
}
-(void)dismissKeyBoard:(id)sender{
    NSLog(@"dismissKeyBoard ");
    UITableViewCell *cell=[self.theTableView cellForRowAtIndexPath:self.indexPathNow];
    UITextField *text=(UITextField *)[cell.contentView viewWithTag:12];
    [text resignFirstResponder];
    [text removeFromSuperview];

    NSInteger selectRow=[self.thePickerView selectedRowInComponent:0];
    //[self.arraySelect objectAtIndex:indexPath.row]
    if(self.indexPathNow.row==1){
    if ((selectRow+1)==[self.arrayPicker count]) {
        theScore=-1;
    }else{
        theScore=1;
    }
                            
                                 }
    NSLog(@"%d",theScore);
    
    if ([[arrayPicker objectAtIndex:selectRow] isKindOfClass:[NSString class]]) {
           [self.arrayTabel replaceObjectAtIndex:indexPathNow.row withObject:[arrayPicker objectAtIndex:selectRow]];
    }else{
    [self.arrayTabel replaceObjectAtIndex:indexPathNow.row withObject:[arrayPicker objectAtIndex:selectRow]];
    [self.arrayID replaceObjectAtIndex:indexPathNow.row withObject:[arrayPicker objectAtIndex:selectRow]];
    }
    [self.theTableView reloadData];
    
}



- (void)dealloc {
    [_theTableView release];
    [arrayTabel release];
    [arrayPicker release];
    [arrayID release];
    [indexPathNow release];
    [arrayAction release];
    [_DeleteButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheTableView:nil];
    [self setThePickerView:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
}
@end
