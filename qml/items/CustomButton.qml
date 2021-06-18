import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Button {
    id: btnId

    property url btnIcon
    property url btnIconHover
    property url btnIconDown

    property color btnColor
    property color btnColorMouseOver
    property color btnColorMouseDown

    property color overlayColor: "#ffffff"
    property color overlayColorMouseOver: "#ffffff"
    property color overlayColorbtnColorMouseDown: "#ffffff"

    property int icon_width
    property int icon_height

    property int rect_radius

    property int rect_width
    property int rect_height

    property var cursorShapeVal: Qt.PointingHandCursor

    QtObject{
        id: internal

        property var dynamicColor:
            if(btnId.down){
                btnId.down ? btnColorMouseDown : btnColor
            }
            else {
                btnId.hovered ? btnColorMouseOver : btnColor
            }

        property var dynamicIcon:
            if(btnId.down){
                btnId.down ? btnIconDown : btnIcon
            }
            else {
                btnId.hovered ? btnIconHover : btnIcon
            }

        property var dynamicColorOverlay:
            if(btnId.down){
                btnId.down ? overlayColorbtnColorMouseDown : overlayColor
            }else{
                btnId.hovered ? overlayColorMouseOver : overlayColor
            }
    }


    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
//        border.width: 2

//        width: rect_width
//        height: rect_height
        radius: rect_radius
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: iconBtn
            source: internal.dynamicIcon
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: false
            sourceSize.width: 50
            sourceSize.height: 50
            width: icon_width
            height: icon_height
        }

        ColorOverlay {
            anchors.fill: iconBtn
            source: iconBtn
            antialiasing: true
            color: internal.dynamicColorOverlay
        }

//        MouseArea{
//            anchors.fill: parent
//            hoverEnabled: true
//            cursorShape: cursorShapeVal

//            propagateComposedEvents: true

//            onClicked: mouse.accepted = false;
//            onPressed: mouse.accepted = false;
//            onReleased: mouse.accepted = false;
//            onDoubleClicked: mouse.accepted = false;
//            onPositionChanged: mouse.accepted = false;
//            onPressAndHold: mouse.accepted = false;
//        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
