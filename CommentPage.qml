import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: cmpage
    width: mainwindow.width
    height: mainwindow.height

    ScrollView {
        id: scrollview
        y: toolbar.height + 50
        width: parent.width
        height: parent.height - 135
        contentWidth: cmpage.width + commentview.maxIndent - 20
        contentHeight: cmpage.height + commentview.sizesum
//        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn; interactive: true }
//        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOn; interactive: true }
//        bottomMargin: commentview.height
//        rightMargin: commentview.width
        Rectangle {
            id: postbackground
            property var modelvalue: stackView.mainModel.get(stackView.index)
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
                color: "#FFAB00"
                text: "\ue807"
                state: voted ? "voted" : "not-voted"
                states: [
                    State {
                        name: "voted"
                        PropertyChanges {
                            target: voteicon
                            rotation: 360
                            text: "\ue808"
                        }
                    },
                    State {
                        name: "not-voted"
                        PropertyChanges {
                            target: voteicon
                            rotation: 0
                            text: "\ue807"
                        }
                    }
                ]
                transitions: [
                    Transition {
                        RotationAnimation {
                            duration: 400
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
            property real cmparent: 0
            property real cmid: 0
            property real indent: 0
            property var author
            width: postbackground.width * 0.75
            height: 120
            anchors.top: postbackground.bottom
            anchors.left: postbackground.left
            anchors.topMargin: 15
            border.width: 0.5
            border.color: "#E0E0E0"
            radius: 5
            Rectangle {
                id: replybar
                visible: false
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 5
                color: "#BDBDBD"
                border.width: 0.5
                border.color: "#E0E0E0"
                width: parent.width - 20
                height: 30
                Label {
                    anchors.centerIn: parent
                    text: "Replying to " + commentinput.author
                    font.bold: Font.Medium
                }
                ClickableText {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "fontello"
                    font.pixelSize: 12
                    text: "\ue800"
                    color: "#FF3D00"
                    onClicked: cmpage.disableReplyTo()
                }
            }
            ScrollView {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 15
                width: parent.width - 10
                height: parent.height - 5
                clip: true
                TextArea {
                    id: commenttext
                    placeholderText: "Enter your comment here"
                    wrapMode: TextEdit.Wrap
                    topPadding: replybar.visible ? 20 : 0
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
                ++commentinput.cmid
                commentmodel.insert(commentinput.cmid, commentinput.indent, loginhandler.username, "1 Sec Ago", commenttext.text, commentinput.cmparent)
                cmpage.reset()
            }
        }


        ListView {
            id: commentview
            property real sizesum: 0
            property real maxIndent: 0
            anchors.top: commentsubmitbtn.bottom
            anchors.left: postbackground.left
            anchors.topMargin: 15
            width: postbackground.width
            height: sizesum + cmpage.height - 400
            spacing: 20
            interactive: false
            model: commentmodel.loaded ? commentmodel : 3
            delegate: commentmodel.loaded ? commentdelegate : loadingdelegate

            add: Transition {
                NumberAnimation {
                    property: "x"
                    from: -300
                    duration: 200
                }
            }

            removeDisplaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 400
                }
            }
            addDisplaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 300
                }
            }
            remove: Transition {
                NumberAnimation {
                    property: "x"
                    to: -parent.width
                    duration: 200
                }
            }
        }

        Component {
            id: commentdelegate
            CommentDelegate { }
        }

        Component {
            id: loadingdelegate
            LoadingDelegate { width: commentview.width }
        }

    }

    function replyTo(parent, author, indent) {
        commentinput.cmparent = parent
        commentinput.author = author
        commentinput.indent = indent + 20
        replybar.visible = true
    }
    function disableReplyTo() {
        commentinput.author = ""
        commentinput.indent = 0
        commentinput.cmparent = 0
        replybar.visible = false
    }
    function reset() {
        disableReplyTo();
        commenttext.clear()
    }
}
