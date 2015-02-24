
// SJADNShareController.m

// Seb Jachec

#import "SJADNShareController.h"

@implementation SJADNShareController

- (id)init
{
    self = [super init];
    if (self) {
        _shareViaLocalApps = YES;
    }
    return self;
}

//NSSharingServicePickerDelegate method to insert App.net option
- (NSArray*)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker sharingServicesForItems:(NSArray *)items proposedSharingServices:(NSArray *)proposedServices {
    
    NSMutableArray *sharingServices = proposedServices.mutableCopy;
    
    //Dropdown menu image for ADN
    NSImage *ADNImage = [NSImage imageNamed:@"adn"];
    [ADNImage setTemplate:YES];
    
    NSSharingService *ADNService = [[NSSharingService alloc] initWithTitle:@"App.net" image:ADNImage alternateImage:ADNImage handler:^{
        [self shareItems:items];
        
    }];
    
    [sharingServices insertObject:ADNService atIndex:sharingServices.count];
    
    return sharingServices;
}

//All-purpose sharing method, can be called from anywhere
- (void)shareItems:(NSArray*)items {
    NSString *postText;
    
    for (id theItem in items) {
        if ([theItem isKindOfClass:[NSString class]]) {
            postText = postText? [postText stringByAppendingFormat:@"\n%@",theItem] : theItem;
        }
    }
    
    //Encode the post text, for URLs
    NSString *encodedPostText = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)postText, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    BOOL shared = NO;
    if (_shareViaLocalApps) {
        //Try to share with local apps
        shared = [self shareWithApps:encodedPostText];
    }
    
    //Share on web
    if (!shared) [self shareWithWeb:encodedPostText];
}

- (BOOL)shareWithApps:(NSString*)encodedPostText {
    NSString *kiwi = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:@"com.yourhead.kiwi"];
    NSString *postURL = nil;
    if (kiwi) {
        //Kiwi
        postURL = [NSString stringWithFormat:@"kiwi://post?text=%@",encodedPostText];
        return [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:postURL]];
    } else {
        //Nothing to open with
        return NO;
    }
}

- (BOOL)shareWithWeb:(NSString*)encodedPostText {
    NSString *postURL = [NSString stringWithFormat:@"https://alpha.app.net/intent/post?text=%@",encodedPostText];
    return [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:postURL]];
}

@end