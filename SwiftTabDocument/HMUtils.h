//
//  HMUtils.h
//  SwiftTabDocument
//
//  Created by Scott Horn on 9/06/2014.
//  Copyright (c) 2014 Scott Horn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUtils : NSObject

+ (void) delegate:(id)delegate _something:(id)me didSomething:(BOOL)didCloseAll soContinue:(void *)contextInfo;

@end
