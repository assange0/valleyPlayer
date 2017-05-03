import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0


// 播放列表
Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: 240
    color: "transparent"
    radius: 10

    // 列表头，添加删除等
    Rectangle {
        id: listViewHeader
        height: 24
        width: parent.width
        clip: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#80d9d9d9"

        Rectangle {
            id: removeListBtn
            width: 24
            height: 24
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            color: "#00000000"
            Image {
                anchors.fill: parent
                source: "qrc:/img/img/minus.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = "#50d6c2b9"
                }
                onExited: {
                    parent.color = "#00000000"
                }

                onClicked: playList.removeItem(playList.currentIndex)
            }
        }

        // 清空列表
        Rectangle {
            id: clearListBtn
            width: 24
            height: 24
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
            color: "#00000000"
            Image {
                anchors.fill: parent
                source: "qrc:/img/img/trash.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = "#50d6c2b9"
                }
                onExited: {
                    parent.color = "#00000000"
                }

                onClicked: playList.clear()
            }
        }

        Text {
            anchors.centerIn: parent
            color: "#dddddd"
            text: "播放列表"
            font.family: {
                "Droid Sans"
                "Noto Sans CJK SC"
                "微软雅黑"
            }
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // 歌曲列表
    ListView {
        id: playlistView
        anchors.top: listViewHeader.bottom
        anchors.left: parent.left
        width: parent.width
        height: 206
        focus: true
        model: playList
        currentIndex: -1
        highlightFollowsCurrentItem: false
        highlight: Rectangle {
            width: parent.width
            height: 30
            color: "#44aaaaaa"
            radius: 5
            y: playlistView.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
        delegate: ItemDelegate {
            width: parent.width
            height: 30
            Column {
                Rectangle {
                    width: parent.width
                    height: 30

                    Text {
                        font.pixelSize: 14
                        color: "#cccccc"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        font.family: {
                            "Droid Sans"
                            "Noto Sans CJK SC"
                            "微软雅黑"
                        }
                        text: getFileName(source.toString())
                    }
                }
            }
            onClicked: {
                if (playList.currentIndex === index
                        && player.playbackState === 1) {
                    player.pause()
                } else {
                    playList.currentIndex = index
                    playlistView.currentIndex = index
                    player.play()
                }
                controlBar.setPlaybackIcon()
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {
        }
    }

    function syncListView() {
        playlistView.currentIndex = playList.currentIndex
        console.log("playlist current index: " + playList.currentIndex)
        console.log("listview current index: " + playlistView.currentIndex)
    }

    // 从路径字符串获取文件名
    function getFileName(urlPath) {
        var filename = urlPath.replace(/^.*[\\\/]/, '')
        console.log("getFlieName: " + filename)
        return filename
    }

    //    Connections {
    //        target: playlistView

    //        onMediaRemoved: {

    //        }
    //    }
}
