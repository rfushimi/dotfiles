hs = hs

hs.hotkey.bind({"cmd"}, "Escape", function ()
    -- Open Chrome
    hs.application.launchOrFocus("iTerm")
end)
hs.hotkey.bind({"cmd"}, "1", function ()
    -- Open Chrome
    hs.application.launchOrFocus("Cider")
end)
hs.hotkey.bind({"cmd"}, "2", function ()
    -- Open Chrome
    hs.application.launchOrFocus("Gemini")
end)
hs.hotkey.bind({"cmd"}, "3", function ()
    -- Open Chrome
    hs.application.launchOrFocus("Duckie")
end)
