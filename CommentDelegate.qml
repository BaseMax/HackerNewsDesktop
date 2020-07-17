import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "transparent"
    width: commentview.width
    implicitHeight: 50 + cmtext.height
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: model.indent
        width: parent.width
        height: parent.height
//                implicitWidth: 50 + cmtext.width
        radius: 10
        border.width: 0.8
        border.color: "#E0E0E0"
        Component.onCompleted: {
            commentview.sizesum += 10 + parent.height
            commentview.maxIndent = Math.max(model.indent, commentview.maxIndent)
        }
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height - 15
            width: 2
            color: "#f56565"
        }
        Rectangle {
            id: commentinfo
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width - 40
            height: 20
//                        spacing: 0
            Label {
                id: authortext
                anchors.left: parent.left
                text: model.author
                font.bold: Font.Medium
            }
            Label {
                id: datetext
                anchors.left: authortext.right
                anchors.bottom: authortext.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 2
                text: model.date
                color: "#718096"
                font.pixelSize: 10
                Layout.preferredWidth: 5
            }

            Label {
                id: seprator
                anchors.left: datetext.right
                anchors.bottom: authortext.bottom
                anchors.leftMargin: 5
                text: "|"
                Layout.preferredWidth: 1
            }

            Label {
                id: childnumber
                anchors.left: seprator.right
                anchors.bottom: authortext.bottom
                anchors.leftMargin: 5
                font.pixelSize: 11
                text: model.childs + " reply"
                color: "#f56565"
                Layout.preferredWidth: contentWidth
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        commentmodel.getReplies(index, model.id)
                    }
                }
            }

            Label {
                id: replyicon
                anchors.right: parent.right
                anchors.rightMargin: -5
                font.family: "fontello"
                font.pixelSize: 13
                text: "\uf112"
                color: "#9E9E9E"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        commentmodel.remove(index)
                        commentview.sizesum -= 40 + cmtext.height
                    }
                }
            }

            Label {
                id: removeicon
                visible: loginhandler.username == model.author
                anchors.right: replyicon.left
                anchors.rightMargin: 5
                font.family: "fontello"
                font.pixelSize: 15
                text: "\ue800"
                color: "#FF3D00"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        commentmodel.remove(index)
                        commentview.sizesum -= 40 + cmtext.height
                    }
                }
            }



        }

        Text {
            id: cmtext
            anchors.top: commentinfo.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            width: parent.width - 50
            text: model.text
            wrapMode: Text.Wrap
        }
    }

}
