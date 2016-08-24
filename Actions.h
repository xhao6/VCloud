//
//  Actions.h
//  VCloud
//
//  Created by Hao Xianchao on 8/11/16.
//  Copyright © 2016 v5.cn. All rights reserved.
//

#ifndef Actions_h
#define Actions_h
#import <Vcloud/VCloudIM.h>

@interface Actions : NSObject {
    // variables
    Actions *actions;
}
- (NSDictionary*)httpPost: (NSString*)input_url and_header: (NSDictionary*)input_header and_data: (NSDictionary*)input_data;
- (NSDictionary*)httpGet: (NSString*)input_url and_header: (NSDictionary*)input_header;
- (NSDictionary*)getToken: (NSString*)auth_url and_also: (NSString*)client_id and_also: (NSString*)client_secret;
- (NSDictionary*)getSessionId: (NSDictionary*)api_token api_url: (NSString*)api_url app_user_id: (NSString*)app_user_id;
- (NSDictionary*)testGetSessionId: (NSString*)login_id;
- (void)login: (NSString*)login_id;
- (void)logout;
- (void)singleChat;
- (void)groupChat;
- (void)singleVideo: (NSString*)partner_id;
@end
#endif /* Actions_h */
