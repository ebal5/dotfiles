# My dotfiles #
Make を利用して環境構築を補助する．
各 OS 毎のコマンドと共通のコマンドを用意してあるので対応するものを実行するように．

## Environment ##
zsh の設定や fish の設定，bash の設定は存在するので簡単に利用可能．

```sh
xrandr --output HDMI2 --right-of DP1 --rotate left
feh --bg-fill HDMI2 用の壁紙 DP1 用の壁紙
```
みたいなのを ~/.config/i3/init.local.sh に記述すると画面配置の初期設定と壁紙設定が i3 起動時に行われるようになる．

## Adaptation ##

初期化の最後に visudo コマンドを用いて自身の使用するユーザに xkeysnail ユーザとして xkeysnail を実行する権限を付与すること．

```
user ALL=(ALL) ALL, (xkeysnail) NOPASSWD: /usr/bin/xkeysnail /usr/sbin/xkeysnail xkeysnail
```

### Arch Linux ###

```sh
# main
make archlinux
# if you want GUI packages, use below
make archlinux_opt
```

## XKEYSNAIL 設定 ##
~/.config/xkeysnail/config.py に設定ファイルを置くと i3 の起動と同時に xkeysnail を起動してくれるはず．

設定の例として，SandS と Enter を RIGHT_CTRL とのマルチパーパスにしたものを載せる．
```py
import re
from xkeysnail.transform import *

define_multipurpose_modmap({
    Key.SPACE: [Key.SPACE, Key.LEFT_SHIFT],
    Key.ENTER: [Key.ENTER, Key.RIGHT_CTRL],
})

```

日本語キーボードの場合は Win キーを置きかえる設定が必要．
