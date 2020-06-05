import QtQuick 2.0
import MeeGo.QOfono 0.2
import Sailfish.Silica 1.0

Page {
    id: page

    property string textEnabled: ""
    property string textTopics: ""
    property string textModemPath: ""
    property string textBroadcast: ""
    property string textEmergency: ""

    allowedOrientations: Orientation.Portrait

    Item {
        id: enableIcon
        height: parent.height / 8
        width: parent.width / 2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        IconButton {
            anchors.centerIn: parent
            icon.source: "image://theme/icon-m-refresh"
            onClicked: broadcast.enabled = !broadcast.enabled
        }
    }
    Item {
        id: copyIcon
        height: parent.height / 8
        width: parent.width / 2
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        IconButton {
            anchors.centerIn: parent
            icon.source: "image://theme/icon-m-clipboard"
            onClicked: Clipboard.text = textLine1.text + " - " + textLine2.text + " - " + textLine3.text
        }
    }

    Rectangle {
        height: parent.height - copyIcon.height
        width: parent.width
        anchors {
            top: parent.top
            margins: Theme.paddingMedium
        }
        color: "transparent"

//        color: "black"
//        opacity: Theme.colorScheme == Theme.LightOnDark ? 0.65 : 0.9

        Label {
            id: textLine0
            anchors.top: parent.top
            anchors.horizontalCenter: parent
        }
        Label {
            id: textLine1
            anchors.top: textLine0.bottom
            anchors.horizontalCenter: parent
        }
        Label {
            id: textLine2
            anchors.top: textLine1.bottom
            anchors.horizontalCenter: parent
            text: manager.available ? netreg.name : "Ofono not available"
        }
        Label {
            id: textLine3
            anchors.top: textLine2.bottom
            anchors.horizontalCenter: parent
            text: textEnabled + ", " + textTopics + ", " + textModemPath + ", " + textBroadcast + ", " + textEmergency
        }

        OfonoManager {
            id: manager
            onAvailableChanged: {
                console.log("Ofono is " + available)
               textLine2.text = manager.available ? netreg.currentOperator["Name"].toString() :"Ofono not available"
            }
            onModemAdded: {
                console.log("modem added "+modem)
            }
            onModemRemoved: console.log("modem removed")
        }

        OfonoConnMan {
           id: ofono1
           Component.onCompleted: {
           //    console.log(manager.modems)
               textLine0 = manager.modems
           }
           modemPath: manager.modems[0]
        }

        OfonoModem {
            id: modem1
           modemPath: manager.modems[0]

        }

        OfonoContextConnection {
            id: context1
            contextPath : ofono1.contexts[0]
            Component.onCompleted: {
                textLine1.text = context1.active ? "online" : "offline"
          }
            onActiveChanged: {
                textLine1.text = context1.active ? "online" : "offline"
            }
        }
        OfonoNetworkRegistration {
            modemPath: manager.modems[0]
            id: netreg
            Component.onCompleted: {
                netreg.scan()
            }

          onNetworkOperatorsChanged : {
              console.log("operators :"+netreg.currentOperator["Name"].toString())
            }
        }
        OfonoNetworkOperator {
            id: netop
        }

        OfonoCellBroadcast {
            id: broadcast
            Component.onCompleted: {
                textEnabled = (broadcast.enabled) ? "enabled" : "disabled"
//                textTopics = (broadcast.enabled) ? broadcast.topics : "no topics"
//                textModemPath = (broadcast.enabled) ? broadcast.modemPath : "no modemPath"
            }
//            Component.onEnabledChanged: {
//                textEnabled = (broadcast.enabled) ? "enabled" : "disabled"
//            }
//            Component.onTopicsChanged: {
//                textTopics = broadcast.topics
//            }
//            Component.onModemPathChanged: {
//                textModemPath = broadcast.modemPath
//            }
//            Component.onIncomingBroadcast: {
//                textBroadcast = broadcast.topics
//            }
//            Component.onEmergencyBroadcast: {
//                textEmergency = broadcast.topics
//            }
        }
    }

}
