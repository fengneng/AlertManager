//
//  BBAlertManager.m
//  Test
//
//  Created by zhengyi on 2020/5/16.
//  Copyright © 2020 bili233. All rights reserved.
//

#import "BBAlertManager.h"

@implementation BBAlertItem

@end

@interface BBAlertManager ()

@property (nonatomic) NSMutableArray <BBAlertItem *>*displayQueue;

@property (nonatomic) NSMutableArray <BBAlertItem *>*waitQueue;

@end

@implementation BBAlertManager

+ (instancetype)shared {
    static BBAlertManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BBAlertManager new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.displayQueue = [NSMutableArray new];
        self.waitQueue = [NSMutableArray new];
    }
    return self;
}

- (NSArray *)alertQueue {
    NSMutableArray *array = [self.displayQueue mutableCopy];
    [array addObjectsFromArray:self.waitQueue];
    return array;
}

- (void)tryShowItem:(BBAlertItem *)item {
    
    
    //是否允许添加多个相同type
    if (!item.allowMultiple) {
         for (BBAlertItem *alert in self.alertQueue) {
             if (alert.type == item.type) {
                 NSLog(@"屏幕上已有相同弹窗，return");
                 return;
             }
         }
    }
 
    // 展示队列为空时，可以直接显示弹窗
    if (!self.displayQueue.count) {
        NSLog(@"屏幕上没有其他弹窗，直接展示");
        [self showItem:item];
    } else {
        if (item.level == BBAlertLevelNormal) {
            NSLog(@"屏幕上有其他弹窗，该次不展示弹窗");
            return;
        } else if (item.level == BBAlertLevelAppend) {
            [self willChangeValueForKey:@"waitQueue"];
            [self.waitQueue addObject:item];
            [self didChangeValueForKey:@"waitQueue"];
            NSLog(@"屏幕上有其他弹窗，等现有弹窗消失再展示");
        } else if (item.level == BBAlertLevelForce) {
            NSLog(@"屏幕上有其他弹窗，覆盖展示");
            [self showItem:item];
        }
    }
}

- (void)showItem:(BBAlertItem *)item {

    if (item.level == BBAlertLevelForce) {
        for (BBAlertItem *displayItem in self.displayQueue) {
            if ([displayItem.exclusionTypes containsObject:@(item.type)] ||
                [item.exclusionTypes containsObject:@(displayItem.type)]) {
                [self willChangeValueForKey:@"waitQueue"];
                [self.waitQueue insertObject:item atIndex:0];
                [self didChangeValueForKey:@"waitQueue"];
                NSLog(@"强类型弹窗，但是有互斥类型，移入等待队列");
                return;
            }
        }
    }

    if (item.canShowBlock) {
        BOOL canShow = item.canShowBlock();
        if (!canShow) {
            NSLog(@"弹窗 %ld 不符合展示条件，跳过", item.type);
            [self showNextAlert];
            return;
        }
    }
    
    [self.displayQueue addObject:item];
    if (item.showBlock) {
        item.showBlock();
        NSLog(@"弹窗 %ld 展示", item.type);
    }
}

- (void)removeItem:(BBAlertItem *)item {
    NSLog(@"弹窗 %ld 消失", item.type);
    if ([self.displayQueue containsObject:item]) {
        [self.displayQueue removeObject:item];
    }
    
    [self showNextAlert];
}

- (void)showNextAlert {
    if (self.waitQueue.count) {
        BBAlertItem *nextItem = self.waitQueue.firstObject;
        if (self.displayQueue.count == 0 || nextItem.level == BBAlertLevelForce) {
            [self willChangeValueForKey:@"waitQueue"];
            [self.waitQueue removeObject:nextItem];
            [self didChangeValueForKey:@"waitQueue"];
            [self showItem:nextItem];
        }
    }
}

@end
