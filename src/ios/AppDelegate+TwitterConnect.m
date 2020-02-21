#import "AppDelegate.h"
#import "MainViewController.h"
#import "AppDelegate+TwitterConnect.h"
#import <TwitterKit/TWTRKit.h>
#import <objc/runtime.h>

@implementation AppDelegate (TwitterConnect)

static void swizzleMethod(Class class, SEL destinationSelector, SEL sourceSelector);

+(void)load {
    swizzleMethod([AppDelegate class],
                @selector(application:openURL:options:),
                @selector(twitter_application_options:openURL:options:));
}

- (BOOL)twitter_application_options: (UIApplication *)app
                         openURL: (NSURL *)url
                         options: (NSDictionary *)options
{
    NSLog(@"Twitter openUrl handler called on: %@", url);
    [[Twitter sharedInstance] application:app openURL:url options:options];
    // Cordova app delegate has important logic which should be called
    return [self twitter_application_options:app openURL:url options:options];
}

static void swizzleMethod(Class class, SEL destinationSelector, SEL sourceSelector) {
    Method destinationMethod = class_getInstanceMethod(class, destinationSelector);
    Method sourceMethod = class_getInstanceMethod(class, sourceSelector);

    if (class_addMethod(class, destinationSelector, method_getImplementation(sourceMethod), method_getTypeEncoding(sourceMethod))) {
        class_replaceMethod(class, destinationSelector, method_getImplementation(destinationMethod), method_getTypeEncoding(destinationMethod));
    } else {
        method_exchangeImplementations(destinationMethod, sourceMethod);
    }
}

@end