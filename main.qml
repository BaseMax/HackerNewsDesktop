import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import API.LoginHandler 0.1
import API.NewsModel 0.1
import API.CommentModel 0.1

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
        property bool loginFailed: false
        property var mainModel: stackView.searchMode ? searchmodel : newsmodel
        initialItem: mainpage
        anchors.fill: parent
    }

    MyToolBar { id: toolbar }

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

    CommentModel {
        id: commentmodel
    }

    NewsModel {
        id: newsmodel
        Component.onCompleted: fetchNewsId();
        onIsReadyChanged: {
            if (isReady) {
                getPostInfo()
            }
        }
    }

    Component {
        id: searchmodel
//        loaded: false
        Rectangle {

        }
    }

    LoginHandler {
        id: loginhandler
        property bool loginattempt: false
        property bool signout: false
        onLoginChanged: {
            if (login) {
                stackView.pop()
                stackView.tabBarNeeded = true
                loginhandler.loginattempt = false
                stackView.loginFailed = false
                return
            }
            if (!loginhandler.signout && loginattempt) {
                stackView.loginFailed = true
            }
            loginhandler.loginattempt = false
        }
    }

    Item {
        id: loading
        visible: loginhandler.loginattempt
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            opacity: 0.6
            color: "#212121"
        }
        Label {
            id: loadingchar
            anchors.centerIn: parent
            font.family: "fontello"
            font.pixelSize: 60
            color: "#f56565"
            text: "\ue834"
        }
        RotationAnimation {
            running: true
            target: loadingchar
            from: 0
            to: 360
            duration: 2000
            loops: Animation.Infinite
        }
    }
}
