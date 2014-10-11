//
//  ViewController.h
//  chatapp
//
//  Created by apple on 07/10/14.
//  Copyright (c) 2014 sanhotrasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CFNetwork/CFNetwork.h>
#import "PTSMessagingCell.h"


@interface ViewController : UIViewController<UIAlertViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int connfd;
    int row;
}
@property(nonatomic,retain)UIButton *send;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)NSString *datatosend;
@property(nonatomic,retain)UIAlertView *ale;
@property(nonatomic,retain)NSString *friendmsg;

//chatting window  member
@property (nonatomic,retain) IBOutlet UITableView * tableView;
@property (nonatomic,retain)NSMutableArray * messages;
@property (nonatomic,retain)UIGestureRecognizer *ges;
@property (nonatomic,retain)UITextView *text;
@property (nonatomic,retain)UIButton *motion;
@property (nonatomic,retain)UIView *container;
@property (nonatomic,retain)NSDateFormatter *formatter;

@end
