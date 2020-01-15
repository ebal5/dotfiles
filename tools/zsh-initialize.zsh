export ZPLUG_HOME=~/.zplug
if [ ! -d $ZPLUG_HOME ]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi
