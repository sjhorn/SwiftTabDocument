//
//  HMUtils.m
//  SwiftTabDocument
//
//  Created by Scott Horn on 9/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

#import "HMUtils.h"

@protocol CloseAllCallback <NSObject>
-(void) _something:(id)x didSomething:(BOOL)y soContinue:(void*)z;
@end


@implementation HMUtils

+ (void) delegate:(id)delegate _something:(id)me didSomething:(BOOL)didCloseAll soContinue:(void *)contextInfo {
    [(id<CloseAllCallback>)delegate _something:me didSomething:didCloseAll soContinue:contextInfo];
}

@end
