# swift-simple-matt-chat
==================================

## What's this?

It is a simple chat application that uses the MQTT.

## Update dependencies

```
$ pod install
$ open MqttChat.xcworkspace
```

## Set MQTT Server Info

```
$ vi MqttChat/src/Const.swift
    let MQTT_HOST : String = <YOUR_MQTT_SERVER_INFO>
    let MQTT_USER : String = <YOUR_MQTT_SERVER_INFO>
    let MQTT_PW   : String = <YOUR_MQTT_SERVER_INFO>
    let MQTT_PORT : Int32  = <YOUR_MQTT_SERVER_INFO>
```
