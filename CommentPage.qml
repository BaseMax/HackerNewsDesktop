import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: cmpage
    width: mainwindow.width
    height: mainwindow.height

    ScrollView {
        y: toolbar.height + 50
        width: parent.width
        height: parent.height - 135
//        contentWidth: parent.width
        contentHeight: cmpage.height + commentview.sizesum
//        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn; interactive: true }
//        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOn; interactive: true }
//        bottomMargin: commentview.height
//        rightMargin: commentview.width
        Rectangle {
            id: postbackground
//            property var modelvalue: stackView.mainModel.get(stackView.index)
            x: 90
            width: parent.width / 1.3
            height: 110
            radius: 10
            border.width: 0.5
            border.color: "#E0E0E0"
            Label {
                id: voteicon
                property bool voted: false
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                font.family: "fontello"
                font.pixelSize: 35
                color: "#2E7D32"
                text: "\ue803"
                state: voted ? "voted" : "not-voted"
                states: [
                    State {
                        name: "voted"
                        PropertyChanges {
                            target: voteicon
                            rotation: 180
                            color: "#f56565"
                        }
                    },
                    State {
                        name: "not-voted"
                        PropertyChanges {
                            target: voteicon
                            rotation: 0
                            color: "#2E7D32"
                        }
                    }
                ]
                transitions: [
                    Transition {
                        ColorAnimation {
                            duration: 200
                        }
                        RotationAnimation {
                            duration: 200
                        }
                    }
                ]
                MouseArea {
                    anchors.fill: parent
                    onClicked: voteicon.voted = !voteicon.voted
                    cursorShape: Qt.PointingHandCursor
                }
            }
            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: voteicon.right
                anchors.leftMargin: 15
                spacing: 0
                RowLayout {
                    Label {
                        text: postbackground.modelvalue[3]
                        font.pixelSize: 20
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    Label {
                        text: "(" + postbackground.modelvalue[2] + ")"
                        font.pixelSize: 12
                    }
                }

                RowLayout {
                    spacing: 2
                    Label {
                        font.pixelSize: 11
                        text: postbackground.modelvalue[6] + " pts"
                    }
                    Label {
                        font.pixelSize: 11
                        text: "by " + postbackground.modelvalue[1]
                    }
                    Label {
                        font.pixelSize: 11
                        text: postbackground.modelvalue[4]
                    }
                }
            }
        }


        Rectangle {
            id: commentinput
            width: postbackground.width * 0.75
            height: 120
            anchors.top: postbackground.bottom
            anchors.left: postbackground.left
            anchors.topMargin: 15
            border.width: 0.5
            border.color: "#E0E0E0"
            radius: 5
            ScrollView {
                anchors.left: parent.left
                anchors.leftMargin: 10
                width: parent.width - 10
                height: parent.height - 5
                clip: true
                TextArea {
                    id: commenttext
//                        width: parent.width
//                        anchors.fill: parent
                    placeholderText: "Enter your comment here"
                    wrapMode: TextEdit.Wrap
                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }

        MyButton {
            id: commentsubmitbtn
            anchors.top: commentinput.bottom
            anchors.left: postbackground.left
            anchors.topMargin: 15
            width: 130
            height: 50
//                    texticon.text: "\ue804"
//                    texticon.visible: true
            contentText.text: "Submit"
            contentText.color: "#FAFAFA"
            contentText.font.pixelSize: 17
            contentText.font.bold: Font.Medium
            bgitem.color: "#f56565"
            bgitem.border.width: 0
            bgitem.border.color: "#f56565"
            bgitem.radius: 10
            onClicked: {
                commentmodel.append({username: "SeedPuller", date: "Now", text: commenttext.text})
                commenttext.text = ""
//                        stackView.pop()
//                        tabbar.currentIndex = 0
            }
        }


        ListView {
            id: commentview
            property real sizesum: 0
            anchors.top: commentsubmitbtn.bottom
            anchors.left: postbackground.left
            anchors.topMargin: 15
            width: postbackground.width
            height: count * 400
            spacing: 20
            model: commentmodel
            delegate: Rectangle {
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
                        commentview.sizesum += 40 + cmtext.height
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
        }
    }
}
