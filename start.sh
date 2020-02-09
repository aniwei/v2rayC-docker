#!/bin/sh

#设置v2ray配置文件的路径
V2RAY_CONF_PATH=/etc/v2ray/config.json
#设置privoxy配置文件路径
PRIVOXY_CONF_PATH=/etc/privoxy/config

#启动privoxy
privoxy --user root ${PRIVOXY_CONF_PATH}
#启动v2ray
v2ray -config=${V2RAY_CONF_PATH}