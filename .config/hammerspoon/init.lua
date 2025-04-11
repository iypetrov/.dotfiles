function switch(key, target)
    hs.hotkey.bind({"alt"}, key, function()
        hs.application.launchOrFocus(target)
    end)
end

switch("1", "Brave Browser")
switch("2", "Ghostty")
switch("3", "Notion")
switch("4", "Spotify")
switch("5", "Microsoft Teams")
