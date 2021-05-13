//
//  NSObject+Ext.m
//  XuK
//
//  Created by XuK on 2019/11/14.
//  Copyright © 2019 XuK. All rights reserved.
//

@import ObjectiveC;
#import "NSObject+Ext.h"

@implementation NSObject (Ext)


- (void)listenEvent:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}

- (void)stopListenEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendEvent:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

- (void)sendEvent:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}


+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 若已经存在，则添加会失败
    BOOL didAddMethod = class_addMethod(class,originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    // 若原来的方法并不存在，则添加即可
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (id)associatedObjectForKey:(NSString *)key {
    NSMutableDictionary *objects = objc_getAssociatedObject(self, _cmd);
    return [objects objectForKey:key];
}

- (void)setAssociatedObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *map = objc_getAssociatedObject(self, @selector(associatedObjectForKey:));
    
    if (!map) {
        map = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(associatedObjectForKey:), map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (object) {
        [map setObject:object forKey:key];
    } else {
        [map removeObjectForKey:key];
    }
}



+ (BOOL)isOverridingMethod:(SEL)method ofSuperclass:(Class)superclass {
    IMP imp = class_getMethodImplementation(self, method);
    IMP baseImp = class_getMethodImplementation(superclass, method);
    return (imp && baseImp && imp != baseImp);
}

@end
