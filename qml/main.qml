import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4



//Window {
//    id: window
//    flags: Qt.FramelessWindowHint
//    visible: true
//    height: 300
//    width: 400

//    MouseArea {
//        id: resize
//        anchors {
//            right: parent.right
//            bottom: parent.bottom
//        }
//        width: 15
//        height: 15
//        cursorShape: Qt.SizeFDiagCursor

//        property point clickPos: "1,1"

//        onPressed: {
//            resize.clickPos  = Qt.point(mouse.x,mouse.y)
//            console.log(Qt.point(mouse.x,mouse.y))
//        }

//        onPositionChanged: {


//        }

//        onReleased: {
//            window.height = .75 * window.width
//            var delta = Qt.point(mouse.x-resize.clickPos.x, mouse.y-resize.clickPos.y)
//            window.width += delta.x;
//            window.height += delta.y;
//        }

//        Rectangle {
//            id: resizeHint
//            color: "red"
//            anchors.fill: resize
//        }
//    }
//}


QtObject {
    id: internal

    property var font_family: "Tahoma"

    property var loginWindow: LoginWindow {
        id: loginWindowId
        visible: true
        flags: Qt.Window | Qt.FramelessWindowHint
        title: qsTr("Login")


        Connections {
            target: order_backend

            function onLoginResultSignal(code, result){
                if(code == '700'){
                    var component = Qt.createComponent("MainWindow.qml")
                    var win = component.createObject(internal)
                    loginWindowId.visible = false
                    win.show()
                }
            }
        }
    }
}

//Window {
//   height: login_win.height
//   width: login_win.width
//   visible: true
//   flags: Qt.Window | Qt.FramelessWindowHint

//    LoginWindow {
//        id: login_win
//        flags: Qt.Window | Qt.FramelessWindowHint
//    }
//}

//LoginWindow {
//    id: loginWindow
//    visible: true
//    flags: Qt.Window | Qt.FramelessWindowHint
//    title: qsTr("Login")

//    property var font_family: "Tahoma"

//    Connections {
//        target: order_backend

//        function onLoginResultSignal(code, result){
//            if(code == '700'){
//                var component = Qt.createComponent("MainWindow.qml")
//                var win = component.createObject(0)
//                visible = false
//                root.visible = true
//                win.transientParent = null
//                win.show()
//            }
//        }
//    }
//}
