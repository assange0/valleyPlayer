import QtQuick 2.8
import QtGraphicalEffects 1.0

Rectangle {
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: 240
    color: "transparent"
    radius: 10

    Image {
        id: bg1
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        clip: true
        source: "qrc:/img/img/bg-3.jpg"
        visible: true
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        color: "black"
        radius: 10
        clip: true
        visible: false
    }

    OpacityMask {
        anchors.fill: mask
        source: bg1
        maskSource: mask
    }
}
