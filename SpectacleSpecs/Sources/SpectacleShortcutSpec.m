#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "SpectacleShortcut.h"

SpecBegin(SpectacleShortcut)
describe(@"SpectacleShortcut", ^{
  it(@"should be initialized with a key binding", ^{
    SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                               shortcutKeyBinding:@"option+command+c"];
    expect(shortcut.shortcutCode).to.equal(kVK_ANSI_C);
    expect(shortcut.shortcutModifiers).to.equal(optionKey | cmdKey);
  });

  it(@"should be copied with a new shortcut action", ^{
    SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                     shortcutCode:kVK_ANSI_C
                                                                shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask];
    expect(shortcut.shortcutAction).to.beFalsy;
    expect([shortcut copyWithShortcutAction:^(SpectacleShortcut *shortcut) {}].shortcutAction).to.beTruthy;
  });

  it(@"should trigger shortcut actions", ^{
    __block BOOL shortcutActionTriggered;
    SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                     shortcutCode:kVK_ANSI_C
                                                                shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask
                                                                   shortcutAction:^(SpectacleShortcut *shortcut) {
                                                                     shortcutActionTriggered = YES;
                                                                   }];
    [shortcut triggerShortcutAction];
    expect(shortcutActionTriggered).to.beTruthy;
  });

  it(@"should determine if the shortcut is cleared", ^{
    expect([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:nil] isClearedShortcut]).to.beTruthy;
    expect([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:@""] isClearedShortcut]).to.beTruthy;
    expect([[[SpectacleShortcut alloc] initWithShortcutName:nil
                                               shortcutCode:0
                                          shortcutModifiers:0] isClearedShortcut]).to.beTruthy;
    expect([[[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                               shortcutCode:0
                                          shortcutModifiers:0] isClearedShortcut]).to.beTruthy;
  });

  it(@"should provide a display string", ^{
    expect([[[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                               shortcutCode:kVK_ANSI_C
                                          shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask] displayString]).to.equal(@"⌥⌘C");
  });

  it(@"should provide a key binding", ^{
    SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                               shortcutKeyBinding:@"alt+cmd+c"];
    expect(shortcut.shortcutKeyBinding).to.equal(@"alt+cmd+c");
  });

  it(@"should support equality", ^{
    SpectacleShortcut *shortcut1 = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                      shortcutCode:kVK_ANSI_C
                                                                 shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask];
    SpectacleShortcut *shortcut2 = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
                                                                      shortcutCode:kVK_ANSI_C
                                                                 shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask];
    SpectacleShortcut *shortcut3 = [[SpectacleShortcut alloc] initWithShortcutName:nil
                                                                      shortcutCode:kVK_ANSI_C
                                                                 shortcutModifiers:NSAlternateKeyMask | NSCommandKeyMask];
    expect(shortcut1).to.equal(shortcut2);
    expect(shortcut1).to.equal(shortcut3);
    expect(shortcut1).notTo.equal([[SpectacleShortcut alloc] initWithShortcutName:nil
                                                                     shortcutCode:0
                                                                shortcutModifiers:0]);
  });
});
SpecEnd