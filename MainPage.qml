import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    width: mainwindow.width
    height: mainwindow.height
    Rectangle {
        width: parent.width
        height: parent.height
        color: "#f7fafc"
    }

    Rectangle {
        id: searchbar
        visible: stackView.searchMode
        width: listviewbackground.width
        height: 50
        x: listviewbackground.x
        y: toolbar.height + 20
        color: "transparent"
        RowLayout {
            anchors.fill: parent
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 10
//                        color: "#FAFAFA"
                border.width: 0.5
                border.color: "#E0E0E0"
                TextInput {
                    width: parent.width - 10
                    height: parent.height - 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    maximumLength: 90
                }
            }

            MyButton {
//                        Layout.rightMargin: 70
                Layout.preferredWidth: 90
                texticon.text: "\ue804"
                texticon.visible: true
                contentText.text: "Search"
                contentText.color: "#FAFAFA"
                bgitem.color: "#f56565"
                bgitem.border.width: 0
                bgitem.border.color: "#f56565"
            }
        }
    }

    Rectangle {
        id: listviewbackground
        anchors.horizontalCenter: parent.horizontalCenter
        y: toolbar.height + 50
        width: parent.width / 1.2
        height: parent.height / 1.4
        radius: 10
        border.width: 0.5
        border.color: "#E0E0E0"
        state: stackView.searchMode ? "search" : "normal"
        states: [
            State {
                name: "search"
                PropertyChanges {
                    target: listviewbackground
                    y: toolbar.height + 100
                    height: parent.height / 1.6
                }
            },
            State {
                name: "normal"
                PropertyChanges {
                    target: listviewbackground
                    y: toolbar.height + 50
                    height: parent.height / 1.4
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    target: listviewbackground
                    property: "y"
                    duration: 100
                }
            }
        ]

        ListView {
            id: listview
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            model: model1
            clip: true
            delegate: Item {
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
                                    font.pixelSize: 11
                                    text: model.points + " pts"
                                }
                                Label {
                                    font.pixelSize: 11
                                    text: "by " + model.author
                                }
                                Label {
                                    font.pixelSize: 11
                                    text: model.date + " |"
                                }
                                Label {
                                    font.pixelSize: 11
                                    text: model.comment + " comments"
                                    color: "#f56565"
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            tabbar.currentIndex = -1
                                            stackView.index = index
                                            stackView.push(commentpage)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#E0E0E0"
                    }
                }
            }

        }
    }
}
