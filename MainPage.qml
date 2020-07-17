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
                Layout.preferredWidth: 120
                Layout.preferredHeight: 50
                texticon.text: "\ue804"
                texticon.visible: true
                contentText.text: "Search"
                contentText.color: "#FAFAFA"
                contentText.font.bold: Font.Medium
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
            model: stackView.mainModel.loaded ? stackView.mainModel : 7
            clip: true
            delegate: listview.model.loaded ? newsdelegate : loadingdelegate
//            delegate: LoadingDelegate { }
        }

    }

    Component {
        id: newsdelegate
        NewsDelegate { }
    }
    Component {
        id: loadingdelegate
        LoadingDelegate { }
    }

}
