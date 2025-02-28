hs = hs
hs.loadSpoon("AClock")


hs.hotkey.bind({"cmd", "shift"}, "I", function ()
    hs.spoon.AClock:toggleShow()
end)
