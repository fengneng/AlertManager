//
//  BBAlertManager.h
//  Test
//
//  Created by zhengyi on 2020/5/16.
//  Copyright © 2020 bili233. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BBAlertType) {
    BBAlertTypeNone = 0,
    
    BBAlertTypePush,
    BBAlertTypeLogin,
    BBAlertTypeGuide,
    
    BBAlertType4,
    BBAlertType5,
    BBAlertType6,
    
    BBAlertTypeAll = 9999,
};

typedef NS_ENUM(NSUInteger, BBAlertLevel) {
    BBAlertLevelNormal,     // 如果弹窗队列被占用，则不加入队列，不再展示
    BBAlertLevelAppend,     // 如果弹窗队列被占用，则加到队尾，等弹窗消失顺序展示
    BBAlertLevelForce,      // 立即展示，不管现在有没有弹窗，直接盖在最上层
};

@interface BBAlertItem : NSObject

@property (nonatomic) BOOL allowMultiple;   //允许队列里有多个同type
@property (nonatomic) BBAlertLevel level;   //允许与其他弹窗同时出现

@property (nonatomic, nullable) NSArray *exclusionTypes;  //当level是BBAlertLevelForce时，互斥的弹窗类型；显示队列中有个互斥的类型存在时，会将弹窗放入等待队列首位

@property (nonatomic) BBAlertType type;

@property (nonatomic, nullable) BOOL (^canShowBlock)(void);

@property (nonatomic, nonnull) dispatch_block_t showBlock;

@end

@interface BBAlertManager : NSObject

@property (nonatomic, readonly, nullable) NSMutableArray <BBAlertItem *>*waitQueue;

+ (nonnull instancetype)shared;

- (void)tryShowItem:(nonnull BBAlertItem *)item;

//弹窗释放时必须调用该方法！
- (void)removeItem:(nonnull BBAlertItem *)item;

@end
