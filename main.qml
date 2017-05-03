import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtMultimedia 5.8
import Qt.labs.platform 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    width: 440
    height: 460
    title: qsTr("Valley Player")
    color: "transparent"

    Rectangle {
        id: secBg
        anchors.fill: parent
        color: "transparent"
        radius: 10
        Rectangle {
            id: topArea
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            height: 240
            radius: 10

            Image {
                id: topBg
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                clip: true
                visible: false
                source: "qrc:/img/img/bg-3.jpg"
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
                source: topBg
                maskSource: mask
            }

            FastBlur {
                anchors.fill: parent
                source: topBg
                radius: 32
            }

            SwipeView {
                id: swipeView
                anchors.fill: parent
                currentIndex: 1

                Page {
                    background: Rectangle {
                        anchors.fill: parent
                        opacity: 0
                    }
                    TopBar {
                        id: topBar
                    }
                }

                Page {
                    background: Rectangle {
                        anchors.fill: parent
                        opacity: 0
                    }
                    PlayListView {
                        id: musicList
                    }
                }

                //                Page {
                //                    background: Rectangle {
                //                        anchors.fill: parent
                //                        opacity: 0
                //                    }
                //                    PlayListView {
                //                        id: musicList
                //                    }
            }
        }
    }

    ControlBar {
        id: controlBar
    }

    // 播放器
    MediaPlayer {
        id: player
        volume: 0.7
        readonly property string title: !!metaData.title ? qsTr("%1").arg(
                                                               metaData.title) : metaData.title
                                                           || source
        readonly property string author: !!metaData.author ? qsTr("%1").arg(
                                                                 metaData.author) : metaData.author
                                                             || source
        playlist: Playlist {
            id: playList
        }
        onStatusChanged: {
            if (status === MediaPlayer.EndOfMedia) {
                playList.next()
                musicList.syncListView()
                play()
            }
        }
        onError: {
            playList.removeItem(playList.currentIndex)
            if (playList.currentIndex >= 0) {
                play()
            } else {
                stop()
            }
        }
    }

    // 托盘设置
    SystemTrayIcon {
        id: trayAera
        visible: true
        iconSource: "qrc:/img/img/play.png"
        onActivated: {
            console.log("emit parameter " + reason)
            mainWindow.show()
            mainWindow.raise()
            mainWindow.requestActivate()
        }

        menu: Menu {
            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }
}
