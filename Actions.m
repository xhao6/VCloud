//
//  actions.m
//  VCloud
//
//  Created by Hao Xianchao on 8/11/16.
//  Copyright © 2016 v5.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actions.h"
#import <Vcloud/VCloudIM.h>



@implementation Actions

- (NSDictionary*)httpGet: (NSString*)input_url and_header: (NSDictionary*)input_header {
    // init the url and header from the input
    NSURL *url = [NSURL URLWithString:input_url];
    NSDictionary *header = input_header;
    
    // create a request for the further GET method
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // get the key-values from input_header and add them into the request header
    if ([header count] != 0){
        for (NSString *key in header){
            [request addValue:input_header[key] forHTTPHeaderField:key];
        }
    }
    
    // send the request and get the response
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error;
    NSDictionary *response_dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    // return the result dictionary
    return response_dict;
}

- (NSDictionary*)httpPost: (NSString*)input_url and_header: (NSDictionary*)input_header and_data: (NSDictionary*)input_data {
    // init the url and header from the input
    NSURL *url = [NSURL URLWithString:input_url];
    NSDictionary *header = input_header;
    NSDictionary *params_dict = input_data;
    
    // init a http request
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    // set the HTTP method to POST
    [request setHTTPMethod:@"POST"];
    
    // get the key-values from input_header and add them into the request header
    if ([header count] != 0){
        for (NSString *key in header){
            [request addValue:input_header[key] forHTTPHeaderField:key];
        }
    }
    
    // Create the NSData for the request
    NSString *params = @"";
    for (NSString *key in params_dict){
        params = [params stringByAppendingFormat:@"%@=%@&", key, params_dict[key]];
    }
    params = [params substringToIndex:([params length]-1)];
    // NSLog(@"The ***params is %@", params);
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    // send the http request and get the response
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *response_dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    // return the result dictionary
    return response_dict;
}

- (NSDictionary*)getToken: (NSString*)auth_url and_also: (NSString*)client_id and_also: (NSString*)client_secret {
    // this function returns a dict of authorization like
    // {Authorization = "Bearer 1f2cea9f-12ea-4480-83ca-f0efcb86ae9f"}
    // init parameters
    NSString *url = auth_url;
    NSDictionary *auth_data = [NSDictionary dictionaryWithObjectsAndKeys:client_id, @"client_id", client_secret, @"client_secret", @"client_credentials", @"grant_type", nil];
    NSDictionary *auth_header;
    
    // use the post method to get the auth info
    NSDictionary *auth_result = [[[Actions alloc]init] httpPost:url and_header:auth_header and_data:auth_data];
    
    // format the response and get the results of auth
    NSString *token = [auth_result objectForKey:@"access_token"];
    NSString *token_type = [[auth_result objectForKey:@"token_type"] capitalizedString];
    NSString *auth = @"";
    auth = [auth stringByAppendingFormat:@"%@ %@", token_type, token];
    NSMutableDictionary *auth_dict = [NSMutableDictionary dictionaryWithObject:auth forKey:@"Authorization"];
    return auth_dict;
}

- (NSDictionary*)getSessionId: (NSDictionary*)api_token api_url: (NSString*)api_url app_user_id: (NSString*)app_user_id {
    // create the url for GET method
    NSString *url = @"";
    url = [url stringByAppendingFormat:@"%@?app_user_id=%@", api_url, app_user_id];
    NSLog(@"%@", url);
    
    // send the GET request and get the resopnse
    NSDictionary *result = [[[Actions alloc]init] httpGet:url and_header:api_token];
    NSLog(@"%@", result);
    return result;
}

- (NSDictionary*)testGetSessionId: (NSString*)login_id {
    // Get the authorization info before registering.
    Actions *action = [[Actions alloc]init];
    // init parameters
    NSString *auth_url = @"https://cloudcn.v5.cn/oauth/token";
    NSString *client_id = @"203228";
    NSString *client_secret = @"fbe54068c5eafd5262ff169a1682cca2";
    
    // get the auth info from method get_token
    NSDictionary *auth_dict = [action getToken:auth_url and_also:client_id and_also:client_secret];
    // print the authorization info
    NSLog(@"The final auth is %@", auth_dict);
    
    // url for get session ID and user ID
    NSString *session_url = @"https://cloudcn.v5.cn/open/api/session/auth";
    NSString *app_user_id = login_id;
    
    NSDictionary *session_dict = [action getSessionId:auth_dict api_url:session_url app_user_id:app_user_id];
    NSString *id_res = [[session_dict objectForKey:@"user"] objectForKey:@"id"];
    NSString *session_id_res = [[session_dict objectForKey:@"user"] objectForKey:@"session_id"];
    NSLog(@"ID is: \n%@,\nSession ID is: \n%@", id_res, session_id_res);
    return session_dict;
}

- (void)login: (NSString*)login_id {
    Actions *action = [[Actions alloc]init];
    NSDictionary *session = [action testGetSessionId:login_id];
    NSString *user_id = session[@"user"][@"id"];
    NSString *session_id = session[@"user"][@"session_id"];
    [[VCloudIM sharedInstance] configWithAppKey:@"203228"];
    [[VCloudIM sharedInstance] loginWithUserId:user_id sessionId:session_id successBlock:^{
        //log in success!
    } failedBlock:^(int status, NSString *msg){
        // login failed!
    }];
    
    // After successful logging in, init the user info
    VCloudUserInfo *userInfo = [[VCloudUserInfo alloc] init];
    userInfo.userId = login_id;
    userInfo.avatarUrl = @"sth";
    userInfo.name = login_id;
    
    // Take the action to set the info
    [[VCloudIM sharedInstance] setCurrentUserInfo:userInfo];
}

- (void)logout {
    [[VCloudIM sharedInstance] logout];
}

- (void)singleChat {
    // User ID should be there
//    HWChatViewController *controller = [[HWChatViewController alloc] initWithChatID:@"123456" isGroup:NO];
//    [self.navigationController pushViewController:controller animated:YES]
}

- (void)groupChat {
    // Group ID should be there
//    HWChatViewController *controller = [[HWChatViewController alloc] initWithChatID:@"123456" isGroup:YES];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)singleVideo: (NSString*)partner_id {
    [[VCloudIM sharedInstance] videoCallWithUserId:partner_id];
}
@end





