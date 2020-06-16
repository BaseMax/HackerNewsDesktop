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
        initialItem: mainpage
        anchors.fill: parent
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
                id: toolbar
                width: parent.width
                height: 80
                RowLayout {
                    x: listviewbackground.x
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
                                            tabbar.currentIndex = index
                                        }
                                    }
                                }
                            }
                        }
                    }
                    MyButton {
//                        Layout.fillWidth: true
//                        Layout.alignment: Qt.AlignRight
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
            Rectangle {
                id: listviewbackground
//                anchors.centerIn: parent
                anchors.horizontalCenter: parent.horizontalCenter
                y: toolbar.height + 50
                width: parent.width / 1.2
                height: parent.height / 1.4
                radius: 10
                border.width: 0.5
                border.color: "#E0E0E0"
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
                                    }
                                    Label {
                                        Layout.alignment: Qt.AlignVCenter
                                        font.family: "fontello"
                                        font.pixelSize: 35
                                        color: "green"
                                        text: "\ue803"
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
