*Duotone Custom Filter*

Allows you to take black & white image and colorize it to your heart's content.

Usage:

-webkit-filter: custom(url(duotone.vs) mix(url(duotone.fs) normal source-atop), 50 50 border-box, black BR BG BB, white WR WG WB);

Where all black pixels become (BR, BG, BB)
and all white pixels become (WR, WG, WB)

All color components range from 0 to 255

In the index.html example provided, the SVG file is used as the source for an IMG. The SVG IMG is black and transparent.  To make the transparent parts white, I set the style of the IMG to "background-color: white"


thief.svg courtesy of Igor Yanovskiy, from The Noun Project
