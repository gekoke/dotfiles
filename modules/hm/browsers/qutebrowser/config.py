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
config.bind('ww', 'edit-url', mode='normal')

# c.hints.chars = "arstneiovm"
c.hints.chars = "asdqwe"

c.input.media_keys = False

# External programs
c.editor.command = ['alacritty', '-e', 'nvim', '{}']
c.fileselect.handler = "external"
c.fileselect.single_file.command = ['alacritty', '-e', 'ranger', '--choosefiles={}']
c.fileselect.multiple_files.command = ['alacritty', '-e', 'ranger', '--choosefiles={}']
c.fileselect.folder.command = ['alacritty', '-e', 'ranger', '--choosefiles={}']

# When to show the autocompletion window.
# Valid values:
#   - always: Whenever a completion is available.
#   - auto: Whenever a completion is requested.
#   - never: Never.
c.completion.show = "always"


# Set default search engine
c.url.searchengines = {
    "DEFAULT": "https://www.startpage.com/do/dsearch?query={}&prfe=3cb118d43fb13f55197200f3c961232b5ec7ca40b97f5d90b9b0c07d6e1072a9a86eed1a502f6604607a11415ad58d0263056b08d1b20ddc6c8c8305e0edfca6e016a000f041ffccb8280b30"
}

# Set home page
c.url.default_page = "https://www.startpage.com/do/mypage.pl?prfe=3cb118d43fb13f55197200f3c961232b5ec7ca40b97f5d90b9b0c07d6e1072a9a86eed1a502f6604607a11415ad58d0263056b08d1b20ddc6c8c8305e0edfca6e016a000f041ffccb8280b30"

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
c.content.cookies.accept = "never"
