//
//  ConnectionStatus.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/31.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#ifndef ConnectionStatus_h
#define ConnectionStatus_h

typedef NS_ENUM(NSUInteger, CONNECTION_STATUS){
    RUNNING=1,
    CLOSED,
    CONNECTING,
    CLOSING,
    FETCHING,
    FETCHED,
};

#endif /* ConnectionStatus_h */
