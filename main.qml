import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 1040
    height: 580
    title: qsTr("Stack")
    FontLoader { source: "font/fontello.ttf" }

    StackView {
        id: stackView
        property bool searchMode: false
        initialItem: mainpage
        anchors.fill: parent
    }

    Rectangle {
        id: toolbar
        width: parent.width
        height: 80
        RowLayout {
            x: 90
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 100
            height: parent.height
            RowLayout {
                id: appinfo
                Label {
                    id: appicon
                    font.family: "fontello"
                    text: "\uf111"
                    color: "#f56565"
                    font.pixelSize: 15
                }
                Label {
                    id: appname
                    text: "Hacker News"
                    font.pixelSize: 20
                    font.bold: Font.Medium
                }
            }
            ListView {
                id: tabbar
//                        Layout.alignment: Qt.AlignVCenter
                Layout.bottomMargin: 18
                Layout.leftMargin: 50
//                        Layout.preferredWidth: toolbar.width
                Layout.fillWidth: true
                currentIndex: 0
                orientation: ListView.Horizontal
                interactive: false
                model: ["New", "Top", "Search", "Submit"]
                spacing: 10
                delegate: Item {
                    width: 70
                    height: 20
                    RowLayout {
//                            Layout.leftMargin: 40
                        Label {
                            id: newicon
                            font.family: "fontello"
                            text: tabbar.currentIndex == index ? "\uf111" : "\uf10c"
                            color: "#f56565"
                        }
                        Label {
                            id: newtext
                            text: modelData
                            color: tabbar.currentIndex == index ? "#f56565" : "black"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (modelData == "Search") {
                                        stackView.searchMode = true
                                    }
                                    if (tabbar.currentIndex == 2) {
                                        stackView.searchMode = false
                                    }

                                    tabbar.currentIndex = index
                                }
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
            MyButton {
                Layout.rightMargin: 70
                contentText.text: "Login"
                contentText.color: "#f56565"
                bgitem.color: "transparent"
                bgitem.border.width: 1
                bgitem.border.color: "#f56565"
            }
        }
    }

    Rectangle {
        id: toolbarseprator
        anchors.top: toolbar.bottom
        width: parent.width
        height: 1.5
        color: "#E0E0E0"
    }

    Component {
        id: mainpage
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
//                                anchors.left: parent.left
//                                anchors.leftMargin: 10
                                Layout.leftMargin: 10
                                id: viewcontent
                                Layout.fillWidth: true
                                Layout.preferredHeight: 94
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0
                                    Label {
                                        Layout.alignment: Qt.AlignVCenter
                                        text: index + 1
                                        font.bold: Font.Bold
                                        font.pixelSize: 15
                                        color: "#212121"
                                    }
                                    Label {
                                        id: voteicon
                                        property bool voted: false
                                        Layout.alignment: Qt.AlignVCenter
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
//                                        anchors.verticalCenter: parent.verticalCenter
                                        Layout.alignment: Qt.AlignVCenter
                                        Layout.leftMargin: -20
                                        spacing: 0
                                        RowLayout {
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
    }


    ListModel {
        id: model1
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
            author: "SeedPuller"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
            author: "SeedPuller"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
            author: "SeedPuller"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
            author: "SeedPuller"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
            author: "SeedPuller"
        }

    }
}
