//
//  DataUpdateHelp.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-5-6.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TousuEntity.h"

@protocol DataUpdateHelpDelgate <NSObject>

@optional
- (void)DataUpdateHelp:(id)_self didFinishWithUserInfo:(id)userinfo;

@end

@interface DataUpdateHelp : NSObject

@property (nonatomic,assign) BaseViewController *delegate;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSArray *fujianArray;
@property (nonatomic,assign) id <DataUpdateHelpDelgate> deleagte;

- (void)doUpdateContentWithTitle:(NSString *)title
                        tousuRen:(NSString *)tousuRen
                           phone:(NSString *)phone
                         content:(NSString *)content
                        location:(CLLocationCoordinate2D)location
                         address:(NSString *)address
                         fujians:(NSArray *)fujians
                        delegate:(id)delegate;
@end
