#import "AnalyticsPlugin.h"
#import <Cordova/CDV.h>
#import <Analytics/SEGAnalytics.h>
#import <Segment-GoogleAnalytics/SEGGoogleAnalyticsIntegrationFactory.h>

@implementation AnalyticsPlugin : CDVPlugin

- (void)pluginInitialize
{
    NSLog(@"[cordova-plugin-segment] plugin initialized");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification
{
    NSString* writeKeyPreferenceName;
    NSString* writeKeyPListName;

    //Get app credentials from config.xml or the info.plist if they can't be found
    #ifdef DEBUG
        [SEGAnalytics debug:YES];
        writeKeyPreferenceName = @"analytics_debug_write_key";
        writeKeyPListName = @"AnalyticsDebugWriteKey";
    #else
        [SEGAnalytics debug:NO];
        writeKeyPreferenceName = @"analytics_write_key";
        writeKeyPListName = @"AnalyticsWriteKey";
    #endif

    NSString* writeKey = self.commandDelegate.settings[writeKeyPreferenceName] ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:writeKeyPListName];

    if (writeKey.length) {
        SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:writeKey];
        configuration.shouldUseLocationServices = YES;
        configuration.trackApplicationLifecycleEvents = YES;
        [configuration use:[SEGGoogleAnalyticsIntegrationFactory instance]];
        [SEGAnalytics setupWithConfiguration:configuration];
    } else {
        NSLog(@"[cordova-plugin-segment] ERROR - Invalid write key");
    }
}

- (void)identify:(CDVInvokedUrlCommand*)command
{
    NSString* userId = [command.arguments objectAtIndex:0];
    NSDictionary* traits = [command.arguments objectAtIndex:1];

    if (traits == (id)[NSNull null]) {
        traits = nil;
    }

    [[SEGAnalytics sharedAnalytics] identify:userId traits:traits];
}

- (void)group:(CDVInvokedUrlCommand*)command
{
    NSString* groupId = [command.arguments objectAtIndex:0];
    NSDictionary* traits = [command.arguments objectAtIndex:1];

    if (traits == (id)[NSNull null]) {
        traits = nil;
    }

    [[SEGAnalytics sharedAnalytics] group:groupId traits:traits];
}

- (void)track:(CDVInvokedUrlCommand*)command
{
    NSString* event = [command.arguments objectAtIndex:0];
    NSDictionary* properties = [command.arguments objectAtIndex:1];
    NSDictionary* options = [command.arguments objectAtIndex:2];

    if (properties == (id)[NSNull null]) {
        properties = nil;
    }

    if (options == (id)[NSNull null]) {
        options = nil;
    }

    [[SEGAnalytics sharedAnalytics] track:event properties:properties options:options];
}

- (void)screen:(CDVInvokedUrlCommand*)command
{
    NSString* category = [command.arguments objectAtIndex:0];
    NSString* name = [command.arguments objectAtIndex:1];
    NSDictionary* properties = [command.arguments objectAtIndex:2];
    NSDictionary* options = [command.arguments objectAtIndex:3];

    if (properties == (id)[NSNull null]) {
        properties = [NSMutableDictionary dictionary];
    }

    if (options == (id)[NSNull null]) {
        options = [NSMutableDictionary dictionary];
    }

    if (category != (id)[NSNull null] && [category length] != 0) {
        [properties setValue:category forKey:@"category"];
    }

    [[SEGAnalytics sharedAnalytics] screen:name properties:properties options:options];
}

- (void)alias:(CDVInvokedUrlCommand*)command
{
    NSString* newId = [command.arguments objectAtIndex:0];

    [[SEGAnalytics sharedAnalytics] alias:newId];
}

- (void)reset:(CDVInvokedUrlCommand*)command
{
    [[SEGAnalytics sharedAnalytics] reset];
}

- (void)flush:(CDVInvokedUrlCommand*)command
{
    [[SEGAnalytics sharedAnalytics] flush];
}

- (void)enable:(CDVInvokedUrlCommand*)command
{
    [[SEGAnalytics sharedAnalytics] enable];
}

- (void)disable:(CDVInvokedUrlCommand*)command
{
    [[SEGAnalytics sharedAnalytics] disable];
}

@end
