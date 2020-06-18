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
        property bool isLogin: false
        initialItem: commentpage
        anchors.fill: parent
    }

    MyToolBar1 { id: toolbar }

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
