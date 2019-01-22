import QtQuick 2.8
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import QtQuick.XmlListModel 2.0


// 下半区
Rectangle {
    id: root
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    width: parent.width
    height: 230
    color: "#f5f5f5"
    radius: 10

    MouseArea {
        id: dragRegion
        anchors.fill: parent
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            // 鼠标偏移量
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)

            // 如果mainwindow继承自QWidget,用setPos
            mainWindow.setX(mainWindow.x + delta.x)
            mainWindow.setY(mainWindow.y + delta.y)
        }
    }

    // 歌曲信息
    Rectangle {
        id: songInfo
        anchors.top: timeBar.bottom
        anchors.left: parent.left
        width: parent.width / 2
        height: 109
        color: "transparent"

        Label {
            id: songTitle
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.right: parent.right
            elide: Qt.ElideRight
            text: player.title || qsTr("Music")
            font.family: {
                "Droid Sans"
                "Noto Sans CJK SC"
                "微软雅黑"
            }
            font.pointSize: 24
        }

        Label {
            id: songAuth
            anchors.top: songTitle.bottom
            anchors.topMargin: 10
            anchors.left: songTitle.left
            anchors.right: parent.right
            elide: Qt.ElideRight
            text: player.errorString || player.author || qsTr("auth")
            font.family: {
                "Droid Sans"
                "Noto Sans CJK SC"
                "微软雅黑"
            }
            color: "#888888"
            font.pointSize: 10
        }
    }

    // 右上方控制区域
    Rectangle {
        id: rtControl
        anchors.top: timeBar.bottom
        anchors.left: songInfo.right
        width: parent.width / 2
        height: 109
        color: "transparent"

        Rectangle {
            id: favIcon
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -15
            width: 36
            height: 36
            color: "transparent"

            Image {
                id: loveMusic
                anchors.fill: parent
                source: "qrc:/img/img/love.png"
            }
        }
    }

    // 左下方设置区域
    Rectangle {
        id: lbControl
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 140
        height: 109
        radius: 10
        color: "transparent"

        // 添加音乐
        Rectangle {
            id: addListArea
            width: 32
            height: 32
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 20
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            Image {
                id: folderIcons
                anchors.fill: parent
                source: "qrc:/img/img/folderAdd.png"
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: addListArea.color = "#dfdfdf"
                    onExited: addListArea.color = "transparent"
                    onPressed: addListArea.color = "#cccccc"
                    onReleased: addListArea.color = "#dfdfdf"
                    onClicked: {
                        swipeView.currentIndex = 1
                        fileDialog.open()
                    }
                }
            }
        }

        Rectangle {
            id: loopIconArea
            width: 32
            height: 32
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -20
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"

            Image {
                id: loopIcon
                anchors.fill: parent
                source: setloopIcon()
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: loopIconArea.color = "#dfdfdf"
                    onExited: loopIconArea.color = "transparent"
                    onPressed: loopIconArea.color = "#cccccc"
                    onReleased: loopIconArea.color = "#dfdfdf"
                    onClicked: {
                        if (playList.playbackMode === 4) {
                            playList.playbackMode = 1
                        } else {
                            playList.playbackMode += 1
                        }
                        setloopIcon()
                    }
                }
            }
        }
    }

    // 右下方设置区域
    Rectangle {
        id: rbControl
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 140
        height: 109
        radius: 10
        color: "transparent"

        // 音量控制区域
        Rectangle {
            id: volumeControler
            width: 32
            height: 32
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -20
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"

            // 音量图标
            Rectangle {
                id: volumeIconRegion
                anchors.fill: parent
                width: 32
                height: parent.height
                radius: 4
                color: "#00000000"
                Image {
                    id: volumeImg
                    width: 32
                    height: 32
                    anchors.centerIn: parent
                    source: "qrc:/img/img/volumHigh.png"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            volumeIconRegion.color = "#dfdfdf"
                            volArea.visible = true
                            console.log("volimage: Enter")
                        }
                        onExited: {
                            if (volArea.focusing !== true
                                    && volumeSlider.hovered !== true) {
                                volArea.visible = false
                            }
                            volumeIconRegion.color = "transparent"
                            console.log("volimage: Exit")
                        }
                        onPressed: volumeIconRegion.color = "#cccccc"
                        onReleased: volumeIconRegion.color = "#dfdfdf"
                        onClicked: {
                            if (player.volume === 0) {
                                volumeSlider.value = 0.3
                            } else {
                                volumeSlider.value = 0
                            }

                            setVolumeIcon()
                        }
                    }
                }
            }
        }

        // 音量条
        Rectangle {
            id: volArea
            anchors.horizontalCenter: volumeControler.horizontalCenter
            anchors.bottom: volumeControler.top
            height: 40
            width: 120
            color: "transparent"
            visible: true
            signal entered
            signal exited
            property bool focusing: false

            Image {
                id: volBg
                anchors.fill: parent
                source: "qrc:/img/img/message.png"

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        volArea.entered()
                    }
                    onExited: {
                        volArea.exited()
                        //                        if (volumeSlider.hovered !== true) {
                        //                            volArea.visible = false
                        //                        }
                    }
                }
            }

            Slider {
                id: volumeSlider
                height: 4
                width: 100
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -5
                value: 0.7
                stepSize: 0.05
                hoverEnabled: true
                onValueChanged: {
                    player.volume = volumeSlider.value
                    setVolumeIcon()
                }

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#f5f5f5"
                    radius: 2
                    Rectangle {
                        height: parent.height
                        width: volumeSlider.value * volumeSlider.width
                        implicitHeight: 4
                        implicitWidth: 100
                        radius: height / 2
                        color: "#ee938b"
                    }
                }

                handle: Rectangle {
                    id: volHandle
                    x: parent.visualPosition * (parent.width - implicitWidth)
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 4
                    implicitHeight: 4
                    radius: 2
                    color: "transparent"
                }

                onHoveredChanged: console.log("hover: " + hovered)
            }

            onEntered: {
                focusing = true
                console.log("volArea: Enter")
            }
            onExited: {
                focusing = false
                console.log("volArea: Exit")
            }
        }

        // 边框按钮
        Rectangle {
            id: borderControl
            width: 32
            height: 32
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 20
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"

            Image {
                id: borderIcon
                source: "qrc:/img/img/window.png"
                anchors.fill: parent
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: borderControl.color = "#dfdfdf"
                    onExited: borderControl.color = "transparent"
                    onPressed: borderControl.color = "#cccccc"
                    onReleased: borderControl.color = "#dfdfdf"
                    onClicked: {
                        borderItems.open()
                    }
                }
            }
        }
    }

    // 播放控制区域
    Rectangle {
        id: controlArea
        anchors.bottom: parent.bottom
        anchors.left: lbControl.right
        anchors.right: rbControl.left
        height: 109
        color: "transparent"

        // 上一首
        Rectangle {
            id: previousMusic
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 50
            height: parent.height
            color: "transparent"

            Rectangle {
                id: peviousArea
                width: 30
                height: 30
                radius: 4
                anchors.centerIn: parent
                color: "transparent"

                Image {
                    id: previousIcon
                    anchors.fill: parent
                    source: "qrc:/img/img/previous.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: peviousArea.color = "#dfdfdf"
                        onExited: peviousArea.color = "transparent"
                        onPressed: peviousArea.color = "#cccccc"
                        onReleased: peviousArea.color = "#dfdfdf"
                        onClicked: {
                            if (playList.previousIndex(1) !== -1) {
                                playList.previous()
                                musicList.syncListView()
                            }
                        }
                    }
                }
            }
        }

        // 播放
        Rectangle {
            id: playMusic
            anchors.bottom: parent.bottom
            anchors.left: previousMusic.right
            anchors.right: nextMusic.left
            height: parent.height
            color: "transparent"

            Rectangle {
                id: playBg1
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -3
                width: parent.width
                height: width
                radius: width / 2
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#dddddd"
                    }
                    GradientStop {
                        position: 0.7
                        color: "#f5f5f5"
                    }
                }

                Rectangle {
                    id: playBg2
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 2
                    width: parent.width - 10
                    height: width
                    radius: width / 2
                    color: "#f5f5f5"
                    border.width: 1
                    border.color: "#dfdfdf"

                    Image {
                        id: playIcon
                        anchors.centerIn: parent
                        width: 30
                        height: 30
                        source: "qrc:/img/img/play.png"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: playBg2.color = "#dfdfdf"
                            onExited: playBg2.color = "#f5f5f5"
                            onPressed: playBg2.color = "#cccccc"
                            onReleased: playBg2.color = "#dfdfdf"

                            onClicked: {
                                if (player.playbackState !== 1) {
                                    player.play()
                                } else {
                                    player.pause()
                                }
                                setPlaybackIcon()
                            }
                        }
                    }
                }
            }
        }

        // 下一首
        Rectangle {
            id: nextMusic
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 50
            height: parent.height
            color: "transparent"

            Rectangle {
                id: nextArea
                width: 30
                height: 30
                radius: 4
                anchors.centerIn: parent
                color: "transparent"

                Image {
                    id: nextIcon
                    anchors.fill: parent
                    source: "qrc:/img/img/next.png"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: nextArea.color = "#dfdfdf"
                        onExited: nextArea.color = "transparent"
                        onPressed: nextArea.color = "#cccccc"
                        onReleased: nextArea.color = "#dfdfdf"
                        onClicked: {
                            if (playList.nextIndex(1) !== -1) {
                                playList.next()
                                musicList.syncListView()
                            }
                        }
                    }
                }
            }
        }
    }

    // 左端时间
    Label {
        id: currentTime
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.top: timeBar.bottom
        anchors.topMargin: 3
        color: "#aaaaaa"

        readonly property int minutes: Math.floor(player.position / 60000)
        readonly property int seconds: Math.round(
                                           (player.position % 60000) / 1000)

        text: Qt.formatTime(new Date(0, 0, 0, 0, minutes, seconds),
                            qsTr("mm:ss"))
        font.family: "Arial"
        font.pointSize: 8
    }
    // 右端时间
    Label {
        id: totalTime
        anchors.right: parent.right
        anchors.rightMargin: 3
        anchors.top: timeBar.bottom
        anchors.topMargin: 3
        color: "#aaaaaa"
        readonly property int minutes: Math.floor(player.duration / 60000)
        readonly property int seconds: Math.round(
                                           (player.duration % 60000) / 1000)

        text: Qt.formatTime(new Date(0, 0, 0, 0, minutes, seconds),
                            qsTr("mm:ss"))
        font.family: "Arial"
        font.pointSize: 8
    }

    TimeBar {
        id: timeBar
    }

    FileDialog {
        id: fileDialog
        selectMultiple: true
        title: "选择音乐"
        folder: musicUrl
        nameFilters: ["音乐文件 (*.mp3 *.wma *.flac *.ape)", "所有文件 (*)"]
        onAccepted: {
            console.log("Accepted: " + fileUrls)
            playList.addItems(fileUrls)
            //            if (true !== playList.save("file:///home/roger/Music/playlist.xml", "xml"))
            //            {
            //                console.log("save")
            //            }
        }
    }

    BorderItems {
        id: borderItems
        width: 440
    }
    // 设置播放时按钮图标
    function setPlaybackIcon() {
        if (player.playbackState === 1) {
            playIcon.source = "qrc:/img/img/pause.png"
        } else {
            playIcon.source = "qrc:/img/img/play.png"
        }
    }

    // 设置循环按钮图标
    function setloopIcon() {
        if (playList.playbackMode === 1) {
            loopIcon.source = "qrc:/img/img/repeat.png"
        } else if (playList.playbackMode === 2) {
            loopIcon.source = "qrc:/img/img/list.png"
        } else if (playList.playbackMode === 3) {
            loopIcon.source = "qrc:/img/img/loop.png"
        } else if (playList.playbackMode === 4) {
            loopIcon.source = "qrc:/img/img/shuffle.png"
        }
    }

    // 设置音量图标
    function setVolumeIcon() {
        if (volumeSlider.value > 0.6) {
            volumeImg.source = "qrc:/img/img/volumHigh.png"
        } else if (volumeSlider.value > 0) {
            volumeImg.source = "qrc:/img/img/volumeLow.png"
        } else if (volumeSlider.value === 0) {
            volumeImg.source = "qrc:/img/img/volumeMute.png"
        }
    }

    //    function setBtnColor(areaBtn) {
    //        if (areaBtn.Entered) {
    //            areaBtn.color = "#dfdfdf"
    //        }
    //        if (areaBtn.Entered) {
    //            areaBtn.color = "#f5f5f5"
    //        }
    //        if (areaBtn.Pressed) {
    //            areaBtn.color = "#cccccc"
    //        }
    //        if (areaBtn.Released) {
    //            areaBtn.color = "#dfdfdf"
    //        }

    //        console.log("color: " + areaBtn.color)
    //        return areaBtn.color
    //    }
}
