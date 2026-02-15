/* See LICENSE file for copyright and license details. */

// Including header file for XF86 keys (function keys)
#include <X11/XF86keysym.h>
#include <X11/keysym.h>

/* appearance */
static const unsigned int borderpx  = 3;       /* border pixel of windows */
static const unsigned int gappx     = 12;      /* gaps between windows */
static const unsigned int snap      = 32;      /* snap pixel */
static const int showbar            = 1;       /* 0 means no bar */
static const int topbar             = 1;       /* 0 means bottom bar */
static const int user_bh            = 12;      /* 2 is the default spacing around the bar's font */

/* System tray */
static const unsigned int systraypinning    = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft     = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing    = 2;   /* systray spacing */
static const int systraypinningfailfirst    = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray                = 1;   /* 0 means no systray */

static const char *fonts[]          = { "JetBrainsMono Nerd Font:style=Bold:size=12" };

// Summer colors
// col_gray1 = "#222222"
// col_gray3 = "#BBBBBB"
// col_gray4 = "#262626"
// col_cyan  = "#f6be00"

// Winter colors
// col_gray1 = "#13294B"
// col_gray3 = "#BDBDBD"
// col_gray4 = "#13294B"
// col_cyan  = "#9DB9D5"

// Autumn colors
// col_gray1 = "#394A2E"
// col_gray3 = "#BDBDBD"
// col_gray4 = "#394A2E"
// col_cyan  = "#B2BA68"

// Spring colors
// col_gray1 = "#1F5533"
// col_gray3 = "#BDBDBD"
// col_gray4 = "#1F5533"
// col_cyan  = "#0EBECE"

//background color
static const char col_gray1[]       = "#1F5533";
//inactive window border color
static const char col_gray2[]       = "#444444";
//font color
static const char col_gray3[]       = "#BDBDBD";
//current tag and current window font
static const char col_gray4[]       = "#1F5533";
//Top bar second color and active window border color
static const char col_cyan[]        = "#0EBECE";
static const char *colors[][3]      = {
  /*               fg         bg         border   */
  [SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
  [SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { " ", " ", " ", " ", " ", " ", " ", " ", " " };

static const Rule rules[] = {
  /* xprop(1):
   *	WM_CLASS(STRING) = instance, class
   *	WM_NAME(STRING) = title
   */
  /* class      instance    title       tags mask     isfloating   monitor */
  { "Gimp",     NULL,       NULL,       0,            0,           -1 },
  { "Thunar",   NULL,       NULL,       0,            1,           -1 },
  { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact        = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;    /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
  /* symbol     arrange function */
  { "[]=",      tile },    /* first entry is default */
  { "><>",      NULL },    /* no layout function means floating behavior */
  { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define MODLAY Mod1Mask
#define TAGKEYS(KEY,TAG)						\
  { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *roficmd[]        = { "rofi", "-show", "drun", NULL }; // if you want to use rofi
static char dmenumon[2]             = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]       = { "dmenu_run", "-m", dmenumon, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]        = { "st", NULL };

/* Constants for volume control */
static const char *upvol[]          = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *downvol[]        = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *mutevol[]        = { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };

/* Constants for brightness control */
static const char *upbright[]       = { "brightnessctl", "set", "5%+", NULL };
static const char *downbright[]     = { "brightnessctl", "set", "5%-", NULL };

/* Programs */
static const char *zenbrowser[]     = { "zen-browser", NULL };
static const char *thunar[]         = { "thunar", NULL };
static const char *emacs[]          = { "emacsclient", "-c", "-a", "'emacs'", NULL };
static const char *passmenu[]       = { "passmenu", "-sb", col_cyan, "-nb", col_gray4, "-nf", col_gray3, "-sf", col_gray4, NULL };
static const char *wezterm[]        = { "wezterm", NULL }; // Why not have another one...

/* Change keyboard layout */
static const char *keymap[]         = { "kblayout", "us", "me", NULL };

static const Key keys[] = {
  /* modifier                     key        function        argument */
  { MODKEY,                       XK_r,      spawn,          {.v = roficmd } },
  { MODKEY,                       XK_p,      spawn,          {.v = passmenu } },
  { MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
  { MODKEY,	                      XK_Return, spawn,          {.v = termcmd } },
  { MODKEY|ShiftMask,	            XK_Return, spawn,          {.v = wezterm } },
  { MODKEY,	                      XK_e,      spawn,          {.v = emacs } },
  { MODKEY,	                      XK_f,      spawn,          {.v = thunar } },
  { MODKEY,	                      XK_w,      spawn,          {.v = zenbrowser } },
  { MODKEY,	                      XK_b,      spawn,          SHCMD("lynx_launch.sh") },
  { MODKEY|ShiftMask,	            XK_s,      spawn,          SHCMD("screenshot.sh") },
  { MODKEY,                       XK_g,      togglebar,      {0} },
  { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
  { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
  { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
  { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
  { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
  { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
  { MODKEY,                       XK_z,      zoom,           {0} },
  { MODKEY,                       XK_Tab,    view,           {0} },
  { MODKEY,	                      XK_q,      killclient,     {0} },
  { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
  { MODKEY,                       XK_y,      setlayout,      {.v = &layouts[1]} },
  { MODKEY,                       XK_u,      setlayout,      {.v = &layouts[2]} },
  { MODKEY,                       XK_s,      setlayout,      {0} },
  { MODKEY|ShiftMask,             XK_t,      togglefloating, {0} },
  { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
  { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
  { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
  { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
  { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
  { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
  TAGKEYS(                        XK_1,                      0)
  TAGKEYS(                        XK_2,                      1)
  TAGKEYS(                        XK_3,                      2)
  TAGKEYS(                        XK_4,                      3)
  TAGKEYS(                        XK_5,                      4)
  TAGKEYS(                        XK_6,                      5)
  TAGKEYS(                        XK_7,                      6)
  TAGKEYS(                        XK_8,                      7)
  TAGKEYS(                        XK_9,                      8)
  { MODKEY|ShiftMask,             XK_q,      quit,           {0} },

  /* Volume control keys */
  { 0,             XF86XK_AudioLowerVolume,  spawn,          {.v = downvol } },
  { 0,             XF86XK_AudioMute,         spawn,          {.v = mutevol } },
  { 0,             XF86XK_AudioRaiseVolume,  spawn,          {.v = upvol   } },
  /* Brightness control keys */
  { 0,             XF86XK_MonBrightnessUp,   spawn,          {.v = upbright } },
  { 0,             XF86XK_MonBrightnessDown, spawn,          {.v = downbright } },
  { MODLAY,        XK_space,                 spawn,          {.v = keymap }},

  /* Same but for external keyboards without Fn lock. Using just F keys */
  { 0,             XK_F1,                    spawn,          { .v = mutevol } },
  { 0,             XK_F3,                    spawn,          { .v = upvol } }, // These two swapped for some reason
  { 0,             XK_F2,                    spawn,          { .v = downvol } },
  /* Brightness control keys */
  { 0,             XK_F6,                    spawn,          { .v = upbright } }, // These also
  { 0,             XK_F5,                    spawn,          { .v = downbright } }
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
  /* click                event mask      button          function        argument */
  { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
  { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
  { ClkWinTitle,          0,              Button2,        zoom,           {0} },
  { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
  { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
  { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
  { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
  { ClkTagBar,            0,              Button1,        view,           {0} },
  { ClkTagBar,            0,              Button3,        toggleview,     {0} },
  { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
  { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
