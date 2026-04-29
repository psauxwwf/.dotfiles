```
https://addons.mozilla.org/en-US/firefox/addon/dracula-dark-colorscheme/
https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/
https://raw.githubusercontent.com/ilyhalight/voice-over-translation/master/dist/vot.user.js
https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/
https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
# https://github.com/mbnuqw/sidebery/releases/download/v5.5.2/sidebery-5.5.2.2.xpi
```

```
about:config

toolkit.legacyUserProfileCustomizations.stylesheets - true
browser.compactmode.show - true
browser.uidensity - true
sidebar.revamp.round-content-area - true

media.ffmpeg.enabled - true
media.navigator.mediadatadecoder_h264_enabled - true
media.hardware-video-decoding.force-enabled - true
```

```
about:profiles

mkdir chrome
touch chrome/userChrome.css
```

```css
#sidebar-main {
  width: clamp(220px, 15vw, 330px) !important;
  min-width: 220px !important;
  max-width: 330px !important;
}
#sidebar-box {
  width: clamp(220px, 15vw, 330px) !important;
  min-width: 220px !important;
  max-width: 330px !important;
}
```

```css
#TabsToolbar {
  display: none !important;
}
#sidebar-box #sidebar-header {
  display: none !important;
}
```
