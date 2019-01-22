import QtQuick 2.8
import QtQuick.Controls 2.1

Drawer {
    id: drawer
    edge: Qt.BottomEdge
    dragMargin: -1
    implicitWidth: parent.width
    implicitHeight: 32

    background: Rectangle {
        color: "#80ffffff"
        radius: 10
    }

    // 退出
    Rectangle {
        id: quitArea
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 32
        height: 32
        radius: 6
        color: "transparent"

        Image {
            anchors.fill: parent
            id: quitIcon
            source: "qrc:/img/img/quitIcon.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: quitArea.color = "#80ffffff"
                onExited: quitArea.color = "transparent"
                //                onPressed: quitArea.color = "#cccccc"
                //                onReleased: quitArea.color = "#dfdfdf"
                onClicked: Qt.quit()
            }
        }
    }

    // 托盘
    Rectangle {
        id: closeArea
        anchors.left: quitArea.right
        anchors.verticalCenter: parent.verticalCenter
        width: 32
        height: 32
        radius: 6
        color: "transparent"

        Image {
            anchors.fill: parent
            id: closeIcon
            source: "qrc:/img/img/closeg.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: closeArea.color = "#80ffffff"
                onExited: closeArea.color = "transparent"
                onClicked: {
                    borderItems.close()
                    mainWindow.hide()
                }
            }
        }
    }
}
