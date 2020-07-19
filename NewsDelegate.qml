import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
//                        anchors.left: parent.left
//                        anchors.leftMargin: 10
    width: listview.width
    height: 100
    ColumnLayout {
        width: parent.width
        height: parent.height
        Rectangle {
            Layout.leftMargin: 10
            id: viewcontent
            Layout.fillWidth: true
            Layout.preferredHeight: 94
            Label {
                id: indexnumber
//                                    Layout.alignment: Qt.AlignVCenter
//                                    Layout.preferredWidth: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text: index + 1
                font.bold: Font.Bold
                font.pixelSize: 15
                color: "#212121"
            }

            Label {
                id: voteicon
                property bool voted: false
//                                    Layout.alignment: Qt.AlignVCenter
//                                    Layout.preferredWidth: 30
                anchors.left: indexnumber.right
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                font.family: "fontello"
                font.pixelSize: 26
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
                    onClicked: {
                        voteicon.voted = !voteicon.voted
                        if (voteicon.voted) {
                            points.text = (model.point + 1) + " pts"
                        } else {
                            points.text = model.point + " pts"
                        }

                    }

                    cursorShape: Qt.PointingHandCursor
                }
            }

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: voteicon.right
                anchors.leftMargin: 15
//                                        width: 100
//                                    Layout.alignment: Qt.AlignVCenter
//                                    Layout.leftMargin: -20
                spacing: 0
                RowLayout {
//                                            Layout.fillWidth: true
//                                            width: 100
                    Label {
                        text: model.title
                        font.pixelSize: 20
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally(model.url);
                        }
                    }
                    Label {
                        text: "(" + model.url + ")"
                        font.pixelSize: 12
                    }
                }

                RowLayout {
                    spacing: 2
                    Label {
                        id: points
                        font.pixelSize: 11
                        text: model.point + " pts"
                    }
                    Label {
                        font.pixelSize: 11
                        text: "by " + model.author + " |"
                    }
//                    Label {
//                        font.pixelSize: 11
//                        text: model.date + " |"
//                    }
                    Label {
                        font.pixelSize: 11
                        text: model.comment + " comments"
                        color: "#f56565"
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!loginhandler.login) {
                                    stackView.tabBarNeeded = false
                                    stackView.push(loginpage)
                                    return;
                                }

                                toolbar.tbar.currentIndex = -1
                                stackView.tabBarNeeded = false
                                stackView.index = index
                                commentmodel.postid = model.id
                                commentmodel.getPostComments()
                                stackView.push(commentpage)
                            }
                        }
                    }

                    ClickableText {
                        visible: model.author == loginhandler.username
                        text: "| delete"
                        color: "#FF3D00"
                        onClicked: stackView.mainModel.remove(index)
                    }
                }
            }

            Label {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                font.pixelSize: 11
                text: model.date
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#E0E0E0"
        }
    }
}
