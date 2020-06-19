import QtQuick 2.0
import QtQuick.Layouts 1.15

Item {
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
            Rectangle {
                id: voteicon
                z: 1
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                width: 60
                height: 65
                radius: 10
                color: "#9E9E9E"
                Rectangle {
                    id: firstrow
                    height: parent.height
                    width: 20
                    x: parent.x
//                                        color: "#FAFAFA"
//                                        radius: 5
                    opacity: 0.8
                }
            }

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: voteicon.right
                anchors.leftMargin: 27
//                                        width: 100
//                                    Layout.alignment: Qt.AlignVCenter
//                                    Layout.leftMargin: -20
                spacing: 7
                Rectangle {
                    id: firstcolumn
                    width: 300
                    height: 25
                    radius: 5
                    color: "#9E9E9E"
                    Rectangle {
                        id: firstcolumnwhite
                        height: parent.height
                        width: 40
                        x: parent.x
//                                        color: "#FAFAFA"
//                                        radius: 5
                        opacity: 0.7
                    }
                }

                Rectangle {
                    id: secondcolumn
                    width: 300
                    height: 25
                    radius: 5
                    color: "#9E9E9E"
                    Rectangle {
                        id: secondcolumnwhite
                        height: parent.height
                        width: 40
                        x: parent.x
//                                        color: "#FAFAFA"
//                                        radius: 5
                        opacity: 0.7
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
    ParallelAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            target: firstcolumnwhite
            property: "x"
            duration: 2000
            from: firstcolumn.x - 20
            to: firstcolumn.width
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: secondcolumnwhite
            property: "x"
            duration: 2000
            from: secondcolumn.x - 20
            to: secondcolumn.width
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: firstrow
            property: "x"
            duration: 2000
            from: voteicon.x - 20
            to: voteicon.width
            easing.type: Easing.OutBack
        }

    }
}
