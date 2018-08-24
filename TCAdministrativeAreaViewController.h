//
//  TCAdministrativeAreaViewController.h
//  TouCe
//
//  Created by Ethan Guo on 2018/3/10.
//  Copyright © 2018年 ebeitech. All rights reserved.
//

#import "BaseViewController.h"
#import "TCAdministrativeAreaModel.h"

@interface TCAdministrativeAreaViewController : BaseViewController


@property (copy, nonatomic) void(^CommitBlock)(NSArray<TCAdministrativeAreaModel *> *array);
@property (assign, nonatomic) TCAdministrativeAreaType toAreaType;

@end
