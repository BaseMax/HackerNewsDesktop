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
        property bool tabBarNeeded: true
        property real index
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
                    text: stackView.tabBarNeeded ? "\uf111" : "\ue801"
                    color: "#f56565"
                    font.pixelSize: 15
                }
                Label {
                    id: appname
                    text: "Hacker News"
                    font.pixelSize: 20
                    font.bold: Font.Medium
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: !stackView.tabBarNeeded
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        stackView.tabBarNeeded = true
                        stackView.pop()
                    }
                }
            }
            ListView {
                id: tabbar
                visible: stackView.tabBarNeeded
                Layout.bottomMargin: 18
                Layout.leftMargin: 50
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
                                enabled: index != tabbar.currentIndex
                                anchors.fill: parent
                                onClicked: {
                                    if (index == 2) {
                                        stackView.searchMode = true
                                    }
                                    if (tabbar.currentIndex == 2) {
                                        stackView.searchMode = false
                                    }
                                    if (stackView.depth > 1) {
                                        stackView.pop()
                                    }
                                    if (index == 3) {
                                        stackView.push(submitpage)
                                    }

                                    tabbar.currentIndex = index
                                    stackView.tabBarNeeded = true
                                }
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
            MyButton {
                visible: stackView.tabBarNeeded
                Layout.rightMargin: 70
                Layout.preferredWidth: 110
                Layout.preferredHeight: 50
                contentText.text: "Login / SignUp"
                contentText.color: "#f56565"
                bgitem.color: "transparent"
                bgitem.border.width: 1
                bgitem.border.color: "#f56565"
                onClicked: {
                    stackView.tabBarNeeded = false
                    stackView.push(loginpage)
//                    tabbar.currentIndex = -1
                }
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
        MainPage { }
    }

    Component {
        id: loginpage
        LoginPage { }
    }

    Component {
        id: submitpage
        SubmitPage { }
    }

    Component {
        id: commentpage
        CommentPage { }
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
    ListModel {
        id: commentmodel
        ListElement {
            username: "SeedPuller"
            date: "1 Day ago"
            text: "Hello this is my comment\nasdasdadnasdasda\dnasdasdasd\nasdasdasdas\nasdasd"
        }


    }
}
