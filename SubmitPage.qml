import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: subpage
    width: mainwindow.width
    height: mainwindow.height
    property bool signup: false
    ColumnLayout {
        id: login
        width: parent.width / 3
        height: parent.height / 3
        anchors.centerIn: parent
        Label {
            text: "Title"
        }
        TextField {
            id: titletext
            Layout.fillWidth: true
            placeholderText: "Enter Title"
        }
        Label {
            text: "URL"
        }
        TextField {
            id: urltext
            Layout.fillWidth: true
            placeholderText: "Enter URL"
        }
        MyButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
//                    texticon.text: "\ue804"
//                    texticon.visible: true
            contentText.text: "Submit"
            contentText.color: "#FAFAFA"
            contentText.font.pixelSize: 17
            contentText.font.bold: Font.Medium
            bgitem.color: "#f56565"
            bgitem.border.width: 0
            bgitem.border.color: "#f56565"
            onClicked: {
                model1.insert(0, {url: urltext.text, title: titletext.text, comment: 0, points: 0, date: "now", author: "SeedPuller"})
                stackView.pop()
                toolbar.tbar.currentIndex = 0
            }
        }
    }

}
