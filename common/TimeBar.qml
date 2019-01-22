import QtQuick 2.8
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Slider {
    id: timeSlider
    from: 0
    to: player.duration
    value: 0
    anchors.left: parent.left
    anchors.top: parent.top
    implicitWidth: parent.width
    implicitHeight: 12

    // 进度条主体
    background: Rectangle {
        id: barBg
        x: 0
        y: 0
        implicitWidth: 200
        implicitHeight: 4
        width: parent.width
        height: parent.height
        gradient: Gradient {
            GradientStop {
                position: 0.00
                color: "#e3e5e2"
            }
            GradientStop {
                position: 0.50
                color: "#efe0e3"
            }
            GradientStop {
                position: 1.00
                color: "#e3e5e2"
            }
        }
        border.width: 1
        border.color: "#e0d6de"

        // 进度条已完成部分
        Rectangle {
            id: readyBg
            anchors.top: parent.top
            anchors.left: parent.left
            width: timeHandle.x + timeHandle.implicitWidth / 2
            height: parent.height
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(parent.x, parent.y)
                end: Qt.point(parent.x + parent.width, parent.y)
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#ebc6d2"
                    }
                    GradientStop {
                        position: readyBg.width / timeSlider.width
                        color: "#8594a8"
                    }
                }
            }
        }
    }

    // 按钮阴影
    Glow {
        id: effect
        anchors.fill: timeHandle
        source: timeHandle
        radius: 5
        spread: 0.2
        color: "#bbbbbb"
        samples: 11
    }

    // 进度条按钮
    handle: Rectangle {
        id: timeHandle
        x: parent.visualPosition * (parent.width - implicitWidth)
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 14
        implicitHeight: 14
        radius: 7
        color: parent.pressed ? "#e0e0e0" : "#ffffff"
        border.width: 1
        border.color: "#d0bfcc"
    }

    // 定时更新进度条
    Timer {
        id: timer
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            // 正在拖拽的时候不更新位置
            if (!parent.pressed) {
                parent.value = player.position
            }
        }
    }

    // 拖动进度条后更新播放器进度
    onPressedChanged: {
        if (!pressed) {
            player.seek(value)
        }
    }
}
