//
//  NSObject+Ext.h
//  XuK
//
//  Created by XuK on 2019/11/14.
//  Copyright © 2019 XuK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Ext)


//监听通知
- (void)listenEvent:(NSString *)name selector:(SEL)selector;
//不再监听通知，XuKBaseViewController 释放时会自动把自己从监听队列中删除掉
- (void)stopListenEvent;

//发送通知
- (void)sendEvent:(NSString *)name;
- (void)sendEvent:(NSString *)name userInfo:(NSDictionary *)userInfo;



//替换方法
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;



//设置associatedObject
- (id)associatedObjectForKey:(NSString *)key;
- (void)setAssociatedObject:(id)object forKey:(NSString *)key;



//判断是否有重写父类的方法
+ (BOOL)isOverridingMethod:(SEL)method ofSuperclass:(Class)superclass;

@end
