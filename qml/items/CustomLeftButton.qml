import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0


Button {
    id: btnDashboard
    text: qsTr('Dashboard')

    property url btnIcon: '../../components/icons//book.svg'

    property color btnColorDefault: '#202224'
    property color btnColorMouseOver: '#2a2c30'
    property color btnColorClicked: "#00a1f1"

    property int icon_width: 25
    property int icon_height: 25

    property int newOrderCount: 0

    property bool activeMenu: false

    width: 200
    height: 80

    background: Rectangle{
        id: bgBtnDashboard
        color: btnColorDefault
    }

    contentItem: Item {
        id: content
        anchors.fill: parent
        clip: true

        // Left Detail
        Rectangle{
            id: leftDetail
            width: activeMenu ? enteredWidth.running = true : exitedWidth.running = true
            height: activeMenu ? enteredHeight.running = true : exitedHeight.running = true
            color: "#FFFFFF"
            radius: 4
            anchors.verticalCenter: content.verticalCenter
            anchors.left: content.left
            anchors.verticalCenterOffset: 0
            anchors.leftMargin: -4
        }

        Image {
            id: iconBtn
            source: btnIcon
            anchors.leftMargin: 13
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            sourceSize.width: icon_width
            sourceSize.height: icon_height
            width: icon_width
            height: icon_height
            fillMode: Image.PreserveAspectFit
            antialiasing: true
        }

        ColorOverlay {
            anchors.fill: iconBtn
            source: iconBtn
            color: '#ffffff'
            antialiasing: true
       }

       Text {
            color: '#ffffff'
            text: btnDashboard.text
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 75
            font.family: font_family
       }

       Rectangle {
           id: numberOfOrders
           x: 28
           y: 40
           width: 20
           height: 20
           color: "#d0d0d0"
           radius: 10
           visible: newOrderCount == 0 ? false : true

           Text {
               id: text1
               anchors.fill: parent
               width: 15
               height: 15
               color: "#202224"
               text: newOrderCount
               font.pixelSize: 13
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
               font.family: "Arial"
               font.kerning: true
               font.strikeout: false
               font.bold: false
               font.italic: false
               minimumPixelSize: 12
           }
       }
   }


    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        propagateComposedEvents: true

        onPressed: mouse.accepted = false;
        onReleased: mouse.accepted = false;
        onDoubleClicked: mouse.accepted = false;
        onPositionChanged: mouse.accepted = false;
        onPressAndHold: mouse.accepted = false;

        onEntered: {
            enteredWidth.running = true
            enteredHeight.running = true
        }
        onExited: {
            exitedWidth.running = true
            exitedHeight.running = true
        }
    }

    // Left Detail

    PropertyAnimation{
        id: enteredWidth
        target: leftDetail
        properties: "width"
        to: 8
        duration: 200
        easing.type: Easing.InOutCubic
    }

    PropertyAnimation{
        id: enteredHeight
        target: leftDetail
        properties: "height"
        to: activeMenu ? content.height - 30 : 20
        duration: 200
        easing.type: Easing.InOutCubic
    }

    PropertyAnimation{
        id: exitedWidth
        target: leftDetail
        properties: "width"
        to: activeMenu ? 8 : 0
        duration: 200
        easing.type: Easing.InOutCubic
    }

    PropertyAnimation{
        id: exitedHeight
        target: leftDetail
        properties: "height"
        to: activeMenu ? content.height - 30 : 0
        duration: 200
        easing.type: Easing.InOutCubic
    }



//    PropertyAnimation{
//        id: detailedNotActive
//        target: leftDetail
//        properties: "height"
//        to: 0
//        duration: 200
//        easing.type: Easing.InOutCubic
//    }

//    PropertyAnimation{
//        id: detailEntered
//        target: leftDetail
//        properties: "height"
//        to: activeMenu ? content.height - 30 : 20
//        duration: 200
//        easing.type: Easing.InOutCubic
//    }
//    PropertyAnimation{
//        id: detailExited
//        target: leftDetail
//        properties: "height"
//        to: activeMenu ? 20 : 0
//        duration: 200
//        easing.type: Easing.InOutCubic
//    }
//    PropertyAnimation{
//        id: detailWidthEntered
//        target: leftDetail
//        properties: "width"
//        to: 8
//        duration: 200
//        easing.type: Easing.InOutCubic
//    }
//    PropertyAnimation{
//        id: detailWidthExited
//        target: leftDetail
//        properties: "width"
//        to: 0
//        duration: 200
//        easing.type: Easing.InOutCubic
//    }

}






/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:2;height:40;width:640}
}
##^##*/
