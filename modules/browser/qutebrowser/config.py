config.load_autoconfig(True)

# Always restore open sites when qutebrowser is reopened.
c.auto_save.session = True

# Background color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.bg = 'darkgreen'

# Bindings for insert mode
config.bind('<Escape>', 'mode-leave', mode='insert')
config.bind('<Ctrl-C>', 'mode-leave', mode='insert')
config.bind('<Ctrl-V>', 'mode-leave', mode='passthrough')
config.bind('<Ctrl-O>', 'back', mode='normal')
config.bind('<Ctrl-I>', 'forward', mode='normal')
config.bind('<Ctrl-Shift-L>', ':spawn --userscript qute-bitwarden --auto-lock=36000', mode='insert')

# c.hints.chars = "arstneiovm"

# When to show the autocompletion window.
# Valid values:
#   - always: Whenever a completion is available.
#   - auto: Whenever a completion is requested.
#   - never: Never.
c.completion.show = "always"


# Set default search engine
c.url.searchengines = { "DEFAULT": "https://search.brave.com/search?q={}" }

# Set home page
c.url.default_page = "https://search.brave.com/"

# Whether quitting the application requires a confirmation.
# Valid values:
#   - always: Always show a confirmation.
#   - multiple-tabs: Show a confirmation if multiple tabs are opened.
#   - downloads: Show a confirmation if downloads are running
#   - never: Never show a confirmation.
c.confirm_quit = ["downloads"]

# Smooth scrolling
c.scrolling.smooth = False

c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://easylist.to/easylist/fanboy-annoyance.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://www.i-dont-care-about-cookies.eu/abp/"
]

c.content.blocking.enabled = True
c.content.blocking.hosts.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts']
c.content.blocking.method = 'both'

c.content.javascript.enabled = False

