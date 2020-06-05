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
        id: contextIcon
        height: parent.height / 6
        width: parent.width / 3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        Label {
            anchors.horizontalCenter: contextIcon.Center
            text: "Context"
        }
        IconButton {
            anchors.centerIn: parent
            icon.source: "image://theme/icon-m-media-radio"
            onClicked: context1.active = !context1.active
        }
    }
    Item {
        id: enableIcon
        height: parent.height / 6
        width: parent.width / 3
        anchors.bottom: parent.bottom
        anchors.left: contextIcon.right
        Label {
            anchors.horizontalCenter: enableIcon.Center
            text: "Broadcast"
        }
        IconButton {
            anchors.centerIn: parent
            icon.source: "image://theme/icon-m-refresh"
            onClicked: broadcast.enabled = !broadcast.enabled
        }
    }
    Item {
        id: copyIcon
        height: parent.height / 6
        width: parent.width / 3
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Label {
            anchors.horizontalCenter: copyIcon.Center
            text: "To Clipboard"
        }
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
            text: "Test #6"
        }
        Label {
            id: textLine1
            anchors.top: textLine0.bottom
            text: context1.active ? "OfonoContextConnection: online" : "OfonoContextConnection: offline"
        }
        Label {
            id: textLine2
            anchors.top: textLine1.bottom
            text: "Network: " + manager.available ? netreg.name : "Ofono not available"
        }
        Label {
            id: textLine3
            anchors.top: textLine2.bottom
            text: textEnabled + ", " + textTopics + ", " + textModemPath + ", " + textBroadcast + ", " + textEmergency
        }

        OfonoManager {
            id: manager
            onAvailableChanged: {
                console.log("Ofono is " + available)
                textLine2.text = "Network: " + manager.available ? netreg.currentOperator["Name"].toString() :"Ofono not available"
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
                textLine1.text = context1.active ? "OfonoContextConnection: online" : "OfonoContextConnection: offline"
          }
            onActiveChanged: {
                textLine1.text = "OfonoContextConnection: " + context1.active ? "changed to online" : "changed to offline"
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
                textEnabled = "OfonoCellBroadcast: " + broadcast.enabled ? "enabled" : "disabled"
                textTopics = broadcast.enabled ? broadcast.topics : "no topics"
                textModemPath = broadcast.enabled ? broadcast.modemPath : "no modemPath"
            }
//            Component.onEnabledChanged: {
//                textEnabled = broadcast.enabled ? "enabled" : "disabled"
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
