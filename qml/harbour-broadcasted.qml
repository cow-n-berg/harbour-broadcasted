import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: generic

    property string textEnabled: "disabled"
    property string textTopics: "no topic"
    property string textModemPath: "no modemPath"
    property string textBroadcast: "no broadcast"
    property string textEmergency: "no emergency"

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
