# Simple way to open in a new tab - support - HUGO

Source: https://discourse.gohugo.io/t/simple-way-to-open-in-a-new-tab/28677/4

This is how I use it:

in my layouts/_default/_markup/render-link.html

To break this down, you can use 4 types of links - External, Internal, mailto and #.

The first if condition parses the link and checks if the destination starts with http or / or #. If it starts with any of those, it’ll add that in the href. The mailto is slightly different. It directly uses the text.

The second if statement is the one that adds the target = "_blank if the link starts with http. For my personal satisfaction, I use JavaScript to force open mailto links in new tab.

Then, in markdown, I can use this like:

1. External link: `[text to link](https://www.foo.com/)`. Make sure to use http or https in the start as that’s how the detection of external link is working. This will open in new tab.

2. Internal link: `[text to link](/link-relative-to-domain)`. Make sure to use relative links or else, if you use absolute ones and end up prefixing them with http, they’ll open in new tab as well. This will open the link in same tab.

3. Hash link: `[text to link](#link)`. This will scroll the element with the id as link. The element should be present in the same page.

3. mailto: `[user@example.com](mailto)`. Just this much configuration is enough. Make sure to use just the word mailto and nothing else and the text to be linked should be an e-mail address.

