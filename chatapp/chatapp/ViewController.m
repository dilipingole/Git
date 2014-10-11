//
//  ViewController.m
//  chatapp
//
//  Created by apple on 07/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import "ViewController.h"
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController
-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addtextboxview];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"my IP=%@",[self getIPAddress]);
    _text.delegate=self;
     [self performSelectorInBackground:@selector(sendmsg) withObject:nil];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getth) userInfo:nil repeats:YES];

    //chat window code
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    row=0;
    _messages=[[NSMutableArray alloc] init];
    _formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MM/yy hh:mm"];
    
    NSArray *arr=[[NSArray alloc] initWithObjects:@"Hello, how are you.",@"1",[_formatter stringFromDate:[NSDate date]], nil];
    [_messages addObject:arr];
    
    
}
-(void)getth
{
    [self performSelectorInBackground:@selector(getmsg) withObject:nil];
}
-(void)getmsg
{
    int sockfd = 0,n = 0;
    char recvBuff[1024];
    char sendBuff[1025];
    struct sockaddr_in serv_addr;
    memset(sendBuff, '0', sizeof(sendBuff));
    memset(recvBuff, '0' ,sizeof(recvBuff));
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0))< 0)
    {
        printf("\n Error : Could not create socket \n");
        //return 1;
    }
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(8000);
    serv_addr.sin_addr.s_addr = inet_addr("192.168.1.5"); //iphone 4s
    
    if(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr))<0)
    {
        printf("\n Error : Connect Failed \n");
       // return 2;
    }
    
    while((n =read(sockfd, recvBuff, sizeof(recvBuff)-1)) > 0)
    {
        recvBuff[n] = 0;
        if(fputs(recvBuff, stdout) == EOF)
        {
            printf("\n Error : Fputs error");
        }
        
        NSString *str=[NSString stringWithFormat:@"%s",recvBuff];
        
        if([str characterAtIndex:str.length-1]=='x')
         {
             NSArray *arr=[[NSArray alloc] initWithObjects:[str substringToIndex:[str length] - 1],@"1",[_formatter stringFromDate:[NSDate date]], nil];
             [_messages addObject:arr];
             [_tableView reloadData];
             [self scrollToBottom];

            str=@"";
        }
        printf("\n");
    }
    if( n < 0)
    {
        printf("\n Read Error \n");
    }
    //return 0;
}
-(void)senddata
{
    _datatosend=[NSString stringWithFormat:@"%@x",_text.text];
    if (_datatosend.length!=0)
    {
        [self soc];
    }
    _datatosend=@"";
    _text.text=@"";
}
-(void)sendmsg
{
    int listenfd = 0;
    struct sockaddr_in serv_addr;
    char sendBuff[1025];
    //char myBuff[1025];
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    printf("socket retrieve success\n");
    
    memset(&serv_addr, '0', sizeof(serv_addr));
    memset(sendBuff, '0', sizeof(sendBuff));
    //  memset(myBuff, '0', sizeof(myBuff));
    
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(5000);
    
    bind(listenfd, (struct sockaddr*)&serv_addr,sizeof(serv_addr));
    
    if(listen(listenfd, 10) == -1){
        printf("Failed to listen\n");
        // return -1;
    }
    while(1)
    {
        connfd = accept(listenfd, (struct sockaddr*)NULL ,NULL); // accept awaiting request
       //strcpy(sendBuff, "You have Message from surabjit");
        // write(connfd, sendBuff, strlen(sendBuff));
        // close(connfd);
        // sleep(1);
        // [self soc];
    }
    //return 0;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([_text.text isEqualToString:@"x"])
    {
        [_text resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_text resignFirstResponder];
}
-(void)soc
{
    char sendBuff[2025];
    [self addmessageintable:_datatosend];
    strcpy(sendBuff,[_datatosend UTF8String]);
    write(connfd, sendBuff, strlen(sendBuff));
    close(connfd);
    sleep(1);
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

//chat code

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *msgdata=[_messages objectAtIndex:indexPath.row];
    CGSize messageSize = [PTSMessagingCell messageSize:[msgdata objectAtIndex:0]];
    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    
    NSArray *msgdata=[_messages objectAtIndex:indexPath.row];
    
    if ([[msgdata objectAtIndex:1]intValue]==1)
    {
        ccell.sent = YES;
        ccell.avatarImageView.image = [UIImage imageNamed:@"me"];
    } else
    {
        ccell.sent = NO;
        ccell.avatarImageView.image = [UIImage imageNamed:@"admin"];
    }
    ccell.messageLabel.text = [msgdata objectAtIndex:0];
    ccell.timeLabel.text = [msgdata objectAtIndex:2];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

-(void)addtextboxview
{
    _container=[[UIView alloc] initWithFrame:CGRectMake(0,420,320,60)];
    _container.backgroundColor=[UIColor grayColor];
    _text=[[UITextView alloc] initWithFrame:CGRectMake(40,2,240,55)];
    _text.layer.cornerRadius=3.0f;
    _text.text=@"type your message here";
    _text.delegate=self;
    
    _send=[[UIButton alloc] initWithFrame:CGRectMake(285,10,35,40)];
    [_send setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    
    [_send addTarget:self action:@selector(senddata) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_text];
    [_container addSubview:_send];
    [self.view addSubview:_container];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _container.frame=CGRectMake(0,206,320,60);
    _text.text=@"";
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    _container.frame=CGRectMake(0,420,320,60);
    return YES;
}
-(void)addmessageintable:(NSString *)data
{
    if (data.length!=0)
    {
       NSArray *arr=[[NSArray alloc] initWithObjects:[data substringToIndex:[data length] - 1],@"0",[_formatter stringFromDate:[NSDate date]], nil];
        [_messages addObject:arr];
        [_text resignFirstResponder];
        [_tableView reloadData];
        [self scrollToBottom];
    }
    else
    {
        _text.text=@"";
    }
}

-(void)scrollToBottom
{
    
    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height) animated:YES];
    
}



@end
