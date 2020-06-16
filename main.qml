import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 1040
    height: 580
    title: qsTr("Stack")


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

            MyToolBar {
                id: toolbar
                barRow.anchors.leftMargin: 100
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
                anchors.centerIn: parent
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
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                id: viewcontent
                                Layout.fillWidth: true
                                Layout.preferredHeight: 94
                                ColumnLayout {
                                    anchors.verticalCenter: parent.verticalCenter
                                    RowLayout {
                                        Label {
                                            text: model.title
                                        }
                                        Label {
                                            text: model.title
                                        }
                                    }
                                    RowLayout {
                                        Label {
                                            text: model.title
                                        }
                                        Label {
                                            text: model.title
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
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
        }
        ListElement {
            url: "https://alsdlasdasd"
            title: "this is the news title"
            comment: 3
            points: 5
            date: "1 day ago"
        }
    }
}
