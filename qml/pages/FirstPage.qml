import QtQuick 2.0
import MeeGo.QOfono 0.2
import QtMultimedia 5.0
import Sailfish.Silica 1.0

Page {
    id: page

    anchors {
        margins: Theme.paddingLarge
        leftMargin: Theme.horizontalPageMargin
        rightMargin: Theme.horizontalPageMargin
    }
    allowedOrientations: Orientation.All

    Audio {
        id: notifAudio
        source: "./enabled.ogg"
    }

    Item {
        id: enableIcon
        height: parent.height / 6
        width: parent.width / 2
        anchors {
            bottom: parent.bottom
            left: parent.left
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
        width: parent.width / 2
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
        IconButton {
            anchors.centerIn: parent
            icon.source: "image://theme/icon-m-clipboard"
            onClicked: Clipboard.text = textLine1.text + " - " + textLine2.text + " - " + textLine3.text + " - " + textLine4.text
        }
    }

    Rectangle {
        height: parent.height - copyIcon.height
        width: parent.width
        anchors {
            top: parent.top
            margins: Theme.paddingLarge
        }
        color: "transparent"

        Label {
            id: textLine0
            anchors {
                top: parent.top
            }
            text: "Test #12"
        }
        TextArea {
            id: textLine1
            anchors {
                top: textLine0.bottom
            }
            label: "OfonoContextConnection"
        }
        TextArea {
            id: textLine2
            anchors {
                top: textLine1.bottom
            }
            label: "Network"
            text: manager.available ? netreg.name : "Ofono not available"
        }
        TextArea {
            id: textLine3
            anchors {
                top: textLine2.bottom
            }
            label: "OfonoCellBroadcast"
            text: textEnabled + ", " + textTopics + ", " + textModemPath + ", " + textBroadcast + ", " + textEmergency
            wrapMode: TextEdit.Wrap
        }
        TextArea {
            id: textLine4
            height: page.height / 4
            anchors {
                top: textLine3.bottom
            }
            label: "OfonoCellBroadcast object"
            text: JSON.stringify(broadcast)
            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
            autoScrollEnabled: true
        }

        OfonoManager {
            id: manager
            onAvailableChanged: {
                console.log("Ofono is " + available)
                textLine2.text = manager.available ? netreg.currentOperator["Name"].toString() :"Ofono not available"
            }
            onModemAdded: {
//                console.log("modem added "+modem)
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
                textLine1.text = context1.active ? "online" : "offline"
          }
            onActiveChanged: {
                textLine1.text = context1.active ? "changed to online" : "changed to offline"
                if (context1.active) {
                    notifAudio.play()
                }
            }
        }

        OfonoNetworkRegistration {
            modemPath: manager.modems[0]
            id: netreg
            Component.onCompleted: {
                netreg.scan()
            }

          onNetworkOperatorsChanged : {
//              console.log("operators :"+netreg.currentOperator["Name"].toString())
            }
        }

        OfonoNetworkOperator {
            id: netop
        }

        OfonoCellBroadcast {
            id: broadcast
            Component.onCompleted: {
                generic.textEnabled = broadcast.enabled ? "enabled" : "disabled"
                generic.textTopics = broadcast.topics
                generic.textModemPath = broadcast.modemPath
//                generic.textBroadcast = broadcast.valid ? "valid" : "invalid"
//                generic.textEmergency = broadcast.toString()
            }
            onEnabledChanged: {
                generic.textEnabled = broadcast.enabled ? "changed to enabled" : "changed to disabled"
                if (broadcast.enabled) {
                    notifAudio.play()
                }
            }
            onTopicsChanged: {
                generic.textTopics = broadcast.topics
            }
            onModemPathChanged: {
                generic.textModemPath = broadcast.modemPath
            }
            onIncomingBroadcast: {
                notifAudio.play()
            }
            onEmergencyBroadcast: {
                notifAudio.play()
            }
        }
    }

}
