import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: logpage
    width: mainwindow.width
    height: mainwindow.height
    property bool signup: false
    ColumnLayout {
        id: login
        width: parent.width / 3
        height: parent.height / 3
        anchors.centerIn: parent
        Label {
            visible: logpage.signup
            text: "Username"
        }
        TextField {
            visible: logpage.signup
            Layout.fillWidth: true
            placeholderText: "Enter your Username"
        }
        Label {
            text: "Email"
        }
        TextField {
            Layout.fillWidth: true
            placeholderText: "Enter your Email"
        }
        Label {
            text: "Password"
        }
        TextField {
            Layout.fillWidth: true
            placeholderText: "Enter your Password"
        }
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "New user?"
            }
            Label {
                text: "Create an account!"
                color: "#f56565"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: logpage.signup = !logpage.signup

                }
            }
        }
        MyButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
//                    texticon.text: "\ue804"
//                    texticon.visible: true
            contentText.text: logpage.signup ? "Sign Up" : "Login"
            contentText.color: "#FAFAFA"
            contentText.font.pixelSize: 17
            contentText.font.bold: Font.Medium
            bgitem.color: "#f56565"
            bgitem.border.width: 0
            bgitem.border.color: "#f56565"
        }
    }

}
