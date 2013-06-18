import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Hooks.SetWMName
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Hooks.ManageDocks
import Graphics.X11
import Control.Monad.Trans
import System.Directory
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.Combo
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.Maximize
import XMonad.Layout.WindowNavigation
import XMonad.Layout.TwoPane
 --- add the following rule to your manageHook list: isFullscreen --> myDoFullFloat
--main = xmonad defaultConfig
--main = xmonad =<< xmobar conf
main = do
    --conf <- dzen defaultConfig 
   -- xmproc <- spawnPipe "xmobar -options -foo -bar"
    xmproc <- spawnPipe "sh /home/chris/.xmonad/hooks/startup"
    xmonad $ defaultConfig
    --h <- spawnPipe "/home/chris/.xmonad/hooks/./startup"
       --as <- "dzen2-gcpubar | dzen2 -ta l -w 180 -x 1080 -fg black -bg orange"
    --xmonad $ conf
	{ modMask = mod1Mask -- mod4Mask Use Super instead of Alt
	, manageHook =  myManageHooks
	, startupHook = setWMName "LG3D"
	, workspaces = map show [1 .. 9 :: Int] 
	--, workspaces = [ show x | x <- [1..9] ]
	, layoutHook = myLayout
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50 
			, ppCurrent = wrap "<fc=#8ae234>[" "]</fc>"
			, ppVisible = wrap "<fc=#8ae234>" "</fc>"
			, ppHidden = wrap "" ""
			, ppHiddenNoWindows = \_ -> ""
			, ppUrgent = wrap "<fc=#ff0000>" "</fc>"
			, ppSep     = " "
                        }
	--, logHook = dynamicLogWithPP $ defaultPP { ppOutput = hPutStrLn h }
       }
myManageHooks = composeAll
-- Allows focusing other monitors without killing the fullscreen
--  [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
-- Single monitor setups, or if the previous hook doesn't work
    [ isFullscreen --> doFullFloat
    ]
 
myLayout = avoidStruts $ layoutHints (tall ||| Mirror tall ||| Full)
  where
     tall = ResizableTall nmaster delta ratio []
     nmaster = 1
     delta   = 3/100
     ratio   = 7/11
    
--myLayout = avoidStruts ( tiled' ||| Mirror tiled' ||| myTabbed ||| Full ||| combo ||| simplestFloat ) ||| Full
  --where
    -- The default number of windows in the master pane
    --nmaster  = 1
    -- Default proportion of screen occupied by master pane
    --ratio    = 2/3
    -- Percent of screen to increment by when resizing panes
    --delta    = 3/100
    -- Tabbed Layout
    --myTabbed = tabbed shrinkText myTabTheme
    -- Shorthand for ResizableTall
    --tiled'   = maximize $ ResizableTall nmaster delta ratio []
    -- Combined layout
    --combo    = windowNavigation ( combineTwo (TwoPane delta ratio) (myTabbed) (tiled') )
    
    
myTabTheme :: Theme
myTabTheme = defaultTheme { fontName = barXFont
                          , activeColor = colorLightBlue
                          , inactiveColor = colorDarkGray
                          , activeBorderColor = colorWhite
                          , inactiveBorderColor = colorLightBlue
                          , activeTextColor = colorWhite
                          , inactiveTextColor = colorLightGray
                          }
                          
colorBlack, colorDarkGray, colorLightGray, colorRed, colorCyan, colorWhite :: [Char]
colorBlack           = "#000000"
colorDarkGray        = "#222222"
colorLightGray       = "#aaaaaa"
colorLightBlue       = "#0066ff"
colorWhite           = "#ffffff"
colorRed             = "#ff0000"
colorCyan            = "#00ffff"
colorMagenta         = "#ff00fd"
colorBlue            = "#003cfd"
colorGreen           = "#00ff00"
colorYellow          = "#fdfd00"
 
barFont, barXFont    :: [Char]
barFont              = "terminus"
barXFont             = "-*-terminus-medium-r-*-*-12-*-*-*-*-*-*-*"
