//
//  VCloudViewController.m
//  VCloud
//
//  Created by Hao Xianchao on 8/11/16.
//  Copyright © 2016 v5.cn. All rights reserved.
//

#import "VCloudViewController.h"
#import "Actions.h"
#import <Vcloud/VCloudIM.h>

@interface VCloudViewController ()<VCloudCallDelegate>

@property (nonatomic, weak)IBOutlet UILabel *screenLabel;

@end


@implementation VCloudViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (IBAction)loginUser1:(id)sender {
    Actions *action = [[Actions alloc] init];
    self.screenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.screenLabel.numberOfLines = 0;
    NSString *login_id = @"test21";
    [action login:login_id];
    NSString *display_text = @"";
    display_text = [display_text stringByAppendingFormat:@"现已登录账户 %@", login_id];
    self.screenLabel.text = display_text;
    [VCloudIM sharedInstance].callDelegate = self;
}

- (IBAction)loginUser2:(id)sender {
    Actions *action = [[Actions alloc] init];
    self.screenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.screenLabel.numberOfLines = 0;
    NSString *login_id = @"test22";
    [action login:login_id];
    NSString *display_text = @"";
    display_text = [display_text stringByAppendingFormat:@"现已登录账户 %@", login_id];
    self.screenLabel.text = display_text;
    [VCloudIM sharedInstance].callDelegate = self;
}


- (IBAction)logOut:(id)sender {
    [[[Actions alloc] init] logout];
    self.screenLabel.text = @"退出登录";
}

- (IBAction)startChat:(id)sender {
    HWChatViewController *controller = [[HWChatViewController alloc] initWithChatID:@"test22" isGroup:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)startGroup:(id)sender {
    // a5173950653a11e6bba7fb907fee57ba
    HWChatViewController *controller = [[HWChatViewController alloc] initWithChatID:@"a5173950653a11e6bba7fb907fee57ba" isGroup:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)startVideo:(id)sender {
    NSString *partner_id = @"test22";
    [[[Actions alloc] init] singleVideo:partner_id];
    NSString *display_text = @"";
    display_text = [display_text stringByAppendingFormat:@"拨打视频电话给 %@ 中......", partner_id];
    self.screenLabel.text = display_text;
}



@end
