#!/bin/bash
# params: <key> <value> <配置文件路径>
function change_config() {
  if [ -f "$3" ] && grep <"$3" -q "$1"; then
    sed -i "s/$1.*/$1=$2/" "$3"
  else
    echo "$1=$2" >>"$3"
  fi
}

# params: <匹配行> <替换行> <文件不存在时的内容> <配置文件路径>
function change_config_next_line() {
  if [ -f "$4" ] && grep <"$4" -q "$1"; then
    sed -i "/$1/{n;s/.*/$2/}" "$4"
  else
    sed -i "1s/^/$3\n/" "$4"
  fi
}

## 开启云拼音
change_config 'CloudPinyinEnabled' 'True' ~/.config/fcitx5/conf/pinyin.conf
change_config 'MinimumPinyinLength' '2' ~/.config/fcitx5/conf/cloudpinyin.conf
change_config 'Backend' 'Baidu' ~/.config/fcitx5/conf/cloudpinyin.conf
## 保持输入法状态
change_config 'ShareInputState' "All" ~/.config/fcitx5/config
## 修改默认加减号翻页
change_config_next_line "\[Hotkey\/PrevPage\]" "0\=minus" "[Hotkey/PrevPage]\n0=minus" ~/.config/fcitx5/config
change_config_next_line "\[Hotkey\/NextPage\]" "0\=equal" "[Hotkey/NextPage]\n0=equal" ~/.config/fcitx5/config
## 关闭预编辑
change_config 'PreeditEnabledByDefault' "False" ~/.config/fcitx5/config
change_config 'PreeditInApplication' "False" ~/.config/fcitx5/conf/pinyin.conf
## 禁用不常用快捷键
# 禁用unicode相关快捷键
change_config 'TriggerKey' "" ~/.config/fcitx5/conf/unicode.conf
change_config 'DirectUnicodeMode' "" ~/.config/fcitx5/conf/unicode.conf
# 云拼音切换快捷键
change_config_next_line '\[Toggle Key\]' '' '' ~/.config/fcitx5/conf/cloudpinyin.conf
sed -i "s/\[Toggle Key\]//" ~/.config/fcitx5/conf/cloudpinyin.conf
change_config 'Toggle Key' '' ~/.config/fcitx5/conf/cloudpinyin.conf
# 简繁体切换
change_config_next_line '\[Hotkey\]' '' '' ~/.config/fcitx5/conf/chttrans.conf
sed -i "s/\[Hotkey\]//" ~/.config/fcitx5/conf/chttrans.conf
change_config 'Hotkey' '' ~/.config/fcitx5/conf/chttrans.conf
# 剪切板
echo -e 'PastePrimaryKey=\nTriggerKey=' >~/.config/fcitx5/conf/clipboard.conf
change_config 'Theme' "$SELECTED_SKIN" ~/.config/fcitx5/conf/classicui.conf
## 设置主题
SELECTED_SKIN=gxde-dark
change_config 'Theme' "$SELECTED_SKIN" ~/.config/fcitx5/conf/classicui.conf
## 重启 fcitx5
killall fcitx5 -9
setsid fcitx5 &